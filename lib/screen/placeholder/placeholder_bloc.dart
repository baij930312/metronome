import 'dart:async';
import 'package:flutter/material.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:metronome/screen/home/home.dart';
import 'package:rxdart/rxdart.dart';

class PlaceholderBloc extends BlocBase {
  //程序启动
  final BehaviorSubject<BuildContext> _app = BehaviorSubject<BuildContext>();
  StreamSubscription<BuildContext> _appStreamSubscription;

  //启动时调用
  Function(BuildContext) get appLaunch => _app.sink.add;

  PlaceholderBloc() {
    _appStreamSubscription = _app
        .transform(DelayStreamTransformer(Duration(seconds: 1)))
        .listen((BuildContext context) {
      Utils.replaceScreen(
          context,
          BlocProvider(
            bloc: HomeBloc(),
            child: HomeScreen(),
          ));
    });
  }

  @override
  void dispose() {
    _appStreamSubscription.cancel();
    _app.close();
  }
}
