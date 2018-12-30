import 'dart:convert';

import 'package:metronome/app/model/local_cache_model.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc extends BlocBase {
//初始读取缓存
  Function(int) get initHandel => initController.sink.add;
  PublishSubject<int> initController = PublishSubject<int>();
  Stream<Function> get _initStream => initController.stream
      .asyncMap((int) async => await initCache())
      .map(_initReducer);
  Function _initReducer(LocalCacheModel initCache) {
    return (LocalCacheModel cache) {
      cache = initCache;
      return cache;
    };
  }

  //设置是否循环
  Function(bool) get loopSettingHandel => _loopSettingController.sink.add;
  PublishSubject<bool> _loopSettingController = PublishSubject<bool>();
  Stream<Function> get _loopSettingStream =>
      _loopSettingController.stream.map(_loopSettingReducer);
  Function _loopSettingReducer(bool flog) {
    return (LocalCacheModel cache) {
      //向本地缓存中添加
      cache.isLoopPlay = flog;
      return cache;
    };
  }

  //设置延迟时间
  Function(int) get delaySettingHandel => _delaySettingController.sink.add;
  PublishSubject<int> _delaySettingController = PublishSubject<int>();
  Stream<Function> get _delaySettingStream =>
      _delaySettingController.stream.map(_delaySettingReducer);
  Function _delaySettingReducer(int delay) {
    return (LocalCacheModel cache) {
      cache.delaySecond = delay;
      return cache;
    };
  }

  //添加
  Function(LocalStoreMetronomeModel) get addHandel => _addMetronome.sink.add;
  PublishSubject<LocalStoreMetronomeModel> _addMetronome =
      PublishSubject<LocalStoreMetronomeModel>();
  Stream<Function> get _addStream => _addMetronome.stream.map(_addReducer);
  Function _addReducer(LocalStoreMetronomeModel model) {
    return (LocalCacheModel cache) {
      //向本地缓存中添加
      cache.metronomesStore.add(model);
      return cache;
    };
  }

  //删除
  Function(LocalStoreMetronomeModel) get deleteHandel =>
      _deleteMetronome.sink.add;
  PublishSubject<LocalStoreMetronomeModel> _deleteMetronome =
      PublishSubject<LocalStoreMetronomeModel>();
  Stream<Function> get _deleteStream =>
      _deleteMetronome.stream.map(_deleteReducer);
  Function _deleteReducer(LocalStoreMetronomeModel model) {
    //向本地缓存中添加
    return (LocalCacheModel cache) {
      cache.metronomesStore.removeWhere((item) {
        return item.creatTimeStamp == model.creatTimeStamp;
      });
      return cache;
    };
  }

//数据出口
  BehaviorSubject<LocalCacheModel> _cacheResource =
      BehaviorSubject<LocalCacheModel>(seedValue: LocalCacheModel());
  Stream<LocalCacheModel> get resource => _cacheResource.stream;
  LocalCacheModel get cacheModel => _cacheResource.value;

  Future<LocalCacheModel> initCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rowJson = prefs.getString(Utils.cacheKey);
    if (rowJson == null) {
      return LocalCacheModel();
    }
    Map jsonMap = json.decode(rowJson);
    return LocalCacheModel.fromJson(jsonMap);
  }

  AppBloc() {
    Observable.merge([
      _addStream,
      _initStream,
      _deleteStream,
      _loopSettingStream,
      _delaySettingStream
    ])
        .transform(ScanStreamTransformer<Function, LocalCacheModel>((
          LocalCacheModel acc,
          Function curr,
          _,
        ) {
          return curr(acc);
        }, LocalCacheModel()))
        .pipe(_cacheResource);
    //当对象改变时 写入缓存
    _cacheResource.listen((LocalCacheModel cache) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Utils.cacheKey, json.encode(cache.toJson()));
    }, onError: (err) {
      print(err);
    });
    initHandel(0);
  }

  @override
  void dispose() {
    _cacheResource.close();
    _addMetronome.close();
    initController.close();
    _deleteMetronome.close();
    _loopSettingController.close();
    _delaySettingController.close();
  }
}

final appBloc = AppBloc();
