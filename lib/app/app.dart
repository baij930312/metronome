import 'package:flutter/material.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:metronome/common/colors.dart';
import 'package:metronome/screen/placeholder/placeholder_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: appColors.mainColor,
        primaryColorBrightness: Brightness.dark,
      ),
      home: BlocProvider(
        child: PlaceholderScreen(),
        bloc: PlaceholderBloc(),
      ),
    );
  }
}
