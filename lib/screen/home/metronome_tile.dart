import 'package:flutter/material.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:metronome/common/utils.dart';
import 'package:metronome/screen/home/model/metronome_model.dart';
import 'package:metronome/screen/home/model/play_state.dart';

class MetronmonTile extends StatefulWidget {
  final MetronomeModel model;
  MetronmonTile(this.model);
  @override
  _MetronmonTileState createState() => _MetronmonTileState(model);
}

class _MetronmonTileState extends State<MetronmonTile> {
  bool isExpand = false;
  MetronomeModel model;

  _MetronmonTileState(this.model);

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    return ExpansionTile(
        title: InkWell(
          splashColor: Color.fromRGBO(0, 0, 0, 0),
          highlightColor: Color.fromRGBO(0, 0, 0, 0),
          onTap: () {
            if (!isExpand) {
              homeBloc.playHandel(model);
            }
          },
          child: _crossFade(
              Container(
                height: 50.0,
                child: Center(
                    child: Text(
                        '${model.counts}小节 ${model.beatsOfBar}拍/小节  ${model.beatsOfMinute}拍/分钟')),
              ),
              Container(
                height: 50.0,
                child: Center(child: Text('请选择')),
              ),
              isExpand),
        ),
        onExpansionChanged: (isExpand) {
          if (!isExpand) {
            Future.delayed(Duration(milliseconds: 300),
                () => homeBloc.modifyHandel(model));
          }
          setState(() {
            this.isExpand = isExpand;
          });
        },
        leading: StreamBuilder<PlayState>(
          stream: homeBloc.playStateStream,
          builder: (BuildContext context, AsyncSnapshot<PlayState> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: 1.0,
              );
            }
            return (snapshot.data.playing &&
                    (snapshot.data.index == model.index))
                ? Container(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: 1.0,
                  );
          },
        ),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
        children: <Widget>[
          ListTile(
            title: Text('每小结${model.beatsOfBar.toInt()}拍(节拍型)'),
            subtitle: Slider(
              onChanged: (double value) {
                this.setState(() {
                  model.beatsOfBar = value.toInt();
                });
              },
              min: 1,
              max: 8,
              value: model.beatsOfBar.toDouble(),
            ),
          ),
          ListTile(
            title: Text('每分钟${model.beatsOfMinute.toInt()}拍(速度)'),
            subtitle: Slider(
              onChanged: (double value) {
                this.setState(() {
                  model.beatsOfMinute = value.toInt();
                });
              },
              min: 0,
              max: 200,
              value: model.beatsOfMinute.toDouble(),
            ),
          ),
          ListTile(
            title: Text('持续${model.counts.toInt()}小结(持续时长)'),
            subtitle: Slider(
              onChanged: (double value) {
                this.setState(() {
                  model.counts = value.toInt();
                });
              },
              min: 0,
              max: 200,
              value: model.counts.toDouble(),
            ),
          ),
        ]);
  }
}
