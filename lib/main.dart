import 'package:metronome/app.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(BlocProvider(
      bloc: appBloc,
      child: App(),
    ));
