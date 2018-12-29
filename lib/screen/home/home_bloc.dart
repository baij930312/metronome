import 'package:metronome/bloc/bloc_provider.dart';
import 'package:metronome/screen/home/model/metronome_model.dart';
import 'package:metronome/screen/home/model/play_state.dart';
import 'package:metronome/screen/home/model/reorder_modeld.dart';
import 'package:rxdart/rxdart.dart';
import 'package:metronome/player/player.dart';

class HomeBloc extends BlocBase {
  final Player player = Player();
  
  BehaviorSubject<PlayState> _playStateController =
      BehaviorSubject<PlayState>();
  BehaviorSubject<MetronomeModel> _playController =
      BehaviorSubject<MetronomeModel>();
  BehaviorSubject<int> _playOutPutController = BehaviorSubject<int>();
  //播放
  Function(MetronomeModel) get playHandel => _playController.sink.add;

  MetronomeModel get currentMetronime => _playController.value;
  int get playIndex => _playOutPutController.value;

  Stream<int> get playStream =>
      _playController.stream.switchMap((MetronomeModel model) {
        if (model.isBegain) {
          List<int> elements = [];
          for (var i = 1; i < model.counts * model.beatsOfBar; i++) {
            elements.add(i);
          }
          return Observable(Stream.fromIterable(elements))
              .interval(
                  Duration(milliseconds: (60000 ~/ (model.beatsOfMinute))))
              .startWith(0);
        } else {
          List<int> elements = [];
          for (var i = 0; i < model.counts * model.beatsOfBar; i++) {
            elements.add(i);
          }
          return Observable(Stream.fromIterable(elements)).interval(
              Duration(milliseconds: (60000 ~/ (model.beatsOfMinute))));
        }
      });
  Stream<PlayState> get playStateStream => _playStateController.stream;
  Stream<int> get playOutPutStream => _playOutPutController.stream;

  //添加
  Function(MetronomeModel) get addHandel => _addMetronome.sink.add;
  PublishSubject<MetronomeModel> _addMetronome =
      PublishSubject<MetronomeModel>();
  Stream<Function> get _addStream => _addMetronome.stream.map(_addReducer);

  Function _addReducer(MetronomeModel model) {
    return (List<MetronomeModel> datas) {
      datas.add(model);
      return datas;
    };
  }

  //修改
  Function(MetronomeModel) get modifyHandel => _modifyMetronome.sink.add;
  PublishSubject<MetronomeModel> _modifyMetronome =
      PublishSubject<MetronomeModel>();
  Stream<Function> get _modifyStream =>
      _modifyMetronome.stream.map(_modifyReducer);

  Function _modifyReducer(MetronomeModel model) {
    return (List<MetronomeModel> datas) {
      int currentIndex = datas.indexWhere((item) {
        return item.index == model.index;
      });
      datas[currentIndex] = model;
      return datas;
    };
  }

  //删除
  Function(MetronomeModel) get deleteHandel => _deleteMetronome.sink.add;
  PublishSubject<MetronomeModel> _deleteMetronome =
      PublishSubject<MetronomeModel>();
  Stream<Function> get _deleteStream =>
      _deleteMetronome.stream.map(_deleteReducer);

  Function _deleteReducer(MetronomeModel model) {
    return (List<MetronomeModel> datas) {
      datas.removeWhere((item) {
        return item.index == model.index;
      });
      return datas;
    };
  }

  //调整顺序
  Function(ReorderModel) get reOrderHandel => _reOrderMetronome.sink.add;
  PublishSubject<ReorderModel> _reOrderMetronome =
      PublishSubject<ReorderModel>();
  Stream<Function> get _reOrderStream =>
      _reOrderMetronome.stream.map(_reOrderReducer);

  Function _reOrderReducer(ReorderModel opt) {
    return (List<MetronomeModel> datas) {
      print(opt.newIndex);
      int oldIndex = opt.oldIndex;
      int newIndex = opt.newIndex;
      MetronomeModel model = datas.removeAt(oldIndex);
      if (opt.newIndex >= opt.oldIndex) {
        datas.insert(newIndex - 1, model);
      } else {
        datas.insert(newIndex, model);
      }
      return datas;
    };
  }

  //替换整个节奏列表
  Function(List<MetronomeModel>) get replaceHandel =>
      _replaceMetronomes.sink.add;
  PublishSubject<List<MetronomeModel>> _replaceMetronomes =
      PublishSubject<List<MetronomeModel>>();
  Stream<Function> get _replaceStream =>
      _replaceMetronomes.stream.map(_replaceReducer);

  Function _replaceReducer(List<MetronomeModel> metronomes) {
    return (List<MetronomeModel> datas) {
      datas = metronomes;
      return datas;
    };
  }

  //数据出口
  BehaviorSubject<List<MetronomeModel>> _metronomeResource =
      BehaviorSubject<List<MetronomeModel>>();
  Stream<List<MetronomeModel>> get resource => _metronomeResource.stream;
  List<MetronomeModel> get metronomes => _metronomeResource.value;

  int indexWithInterval(int begain, int end, int interval, int target) {
    assert(begain <= end);
    assert(interval > 0);
    int res = 0;
    int greater = 0;
    for (var i = begain; i < end; i = i + interval) {
      res++;
      greater = i + interval;
      if ((i <= (target)) && (greater > (target))) {
        return res;
      }
    }
    return -1;
  }

  HomeBloc() {
    playStream.pipe(_playOutPutController);
    playOutPutStream.listen(
      (int i) {
        MetronomeModel model = _playController.value;
        int beatIndex = indexWithInterval(
          0,
          model.beatsOfBar * model.counts,
          model.beatsOfBar,
          i,
        );
        _playStateController.sink.add(PlayState(
          index: model.index,
          playing: true,
          totelCountOfBar: model.counts,
          currentBarIndex: beatIndex,
          totelBeatsOfBar: model.beatsOfBar,
          currentBeatIndex: i % model.beatsOfBar,
        ));
        if ((model.counts * model.beatsOfBar - 1) == i) {
          int currentIndex = _metronomeResource.value.indexWhere((item) {
            return item.index == model.index;
          });
          //当前播放完毕  播放下一条
          if (_metronomeResource.value.length > (currentIndex + 1)) {
            playHandel(_metronomeResource.value[currentIndex + 1]);
          } else {
            _playStateController.sink.add(PlayState(
              index: -1,
              playing: false,
              totelCountOfBar: 1,
              currentBarIndex: 1,
              totelBeatsOfBar: 4,
              currentBeatIndex: -1,
            ));
          }
        }
        player.playLocal();
      },
    );

    Observable.merge([
      _addStream,
      _modifyStream,
      _deleteStream,
      _reOrderStream,
      _replaceStream
    ])
        .transform(ScanStreamTransformer<Function, List<MetronomeModel>>((
      List<MetronomeModel> acc,
      Function curr,
      _,
    ) {
      return curr(acc);
    }, []))
        .startWith([]).pipe(_metronomeResource);
  }

  @override
  void dispose() {
    _metronomeResource.close();
    _addMetronome.close();
    _modifyMetronome.close();
    _playController.close();
    _playOutPutController.close();
    _playStateController.close();
    _deleteMetronome.close();
    _reOrderMetronome.close();
    _replaceMetronomes.close();
  }
}
