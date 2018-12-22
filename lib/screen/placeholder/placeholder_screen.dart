import 'package:metronome/common/images.dart';
import 'package:metronome/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:metronome/bloc/bloc_provider.dart';

class PlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlaceholderBloc placeholderBloc = BlocProvider.of<PlaceholderBloc>(context);
    placeholderBloc.appLaunch(context);
    return Scaffold(
      body: Image.asset(
        imagePaths.placeholder,
        fit: BoxFit.fill,
        height: Utils.getScreenHeight(context),
        width: Utils.getScreenWidth(context),
      ),
    );
  }
}
