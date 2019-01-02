import 'package:flutter/material.dart';
import 'package:metronome/app/model/local_cache_model.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:metronome/screen/home/model/metronome_model.dart';
import 'package:metronome/widget/drag_delete_tile.dart';

enum AlertState {
  cancel,
  confirm,
}

class BottomToolBar extends StatelessWidget {
  const BottomToolBar({this.color, this.fabLocation, this.shape});

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;
  static String name;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  void showSaveDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      if (value == AlertState.confirm) {
        AppBloc appBloc = BlocProvider.of<AppBloc>(context);
        HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
        appBloc.addHandel(LocalStoreMetronomeModel(
            creatTimeStamp: Utils.currentTimeMillis(),
            metronomes: List.from(homeBloc.metronomes),
            name: name));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    final List<Widget> rowContents = <Widget>[
      IconButton(
        icon: const Icon(Icons.menu, semanticLabel: '节奏夹'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => LocalStoreDrawer(bloc),
          );
        },
      ),
    ];
    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: SizedBox()),
      );
    }

    rowContents.addAll(<Widget>[
      IconButton(
        icon: const Icon(
          Icons.save,
          semanticLabel: '保存当前节奏单',
        ),
        onPressed: () {
          showSaveDialog<AlertState>(
              context: context,
              child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('请为这段节奏起个名字吧~'),
                      TextField(
                        autofocus: true,
                        onChanged: (text) {
                          name = text;
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: const Text('取消'),
                        onPressed: () {
                          Navigator.pop(context, AlertState.cancel);
                        }),
                    FlatButton(
                        child: const Text('确认'),
                        onPressed: () {
                          Navigator.pop(context, AlertState.confirm);
                        })
                  ]));
        },
      ),
      // IconButton(
      //   icon: Icon(
      //     Icons.refresh,
      //     semanticLabel: '从头播放',
      //   ),
      //   onPressed: () {
      //     if (!(bloc.metronomes.isEmpty)) {
      //       var model = MetronomeModel.from(bloc.metronomes.first)
      //         ..isBegain = true;
      //       bloc.stopHandel(0);
      //       bloc.playDelayHandel(model);
      //     }
      //   },
      // ),
      IconButton(
        icon: Icon(
          Icons.stop,
          semanticLabel: '停止播放',
        ),
        onPressed: () {
          bloc.stopHandel(0);
        },
      ),
      StreamBuilder(
        stream: bloc.playDelayOriginStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if ((appBloc.cacheModel.delaySecond == 0) ||
                (snapshot.data == appBloc.cacheModel.delaySecond - 1)) {
              return Material();
            }
            return Material(
              child: Text('${snapshot.data + 1}'),
            );
          }
          return Material();
        },
      ),
    ]);

    return BottomAppBar(
      color: color,
      child: Row(children: rowContents),
      shape: shape,
    );
  }
}

class LocalStoreDrawer extends StatelessWidget {
  final HomeBloc bloc;
  const LocalStoreDrawer(this.bloc);
  _handleDelete(item, AppBloc appBloc) {
    appBloc.deleteHandel(item);
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    return StreamBuilder(
      stream: appBloc.resource,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        LocalCacheModel cache = snapshot.data;
        if (!snapshot.hasData) {
          return Container(
            height: Utils.getScreenHeight(context) / 2.0,
            child: Text('没有保存记录'),
          );
        }
        if (cache.metronomesStore.length > 0) {
          List widgets = cache.metronomesStore.map<Widget>((item) {
            return DragDeleteTile<LocalStoreMetronomeModel>(
              key: Key(item.creatTimeStamp.toString()),
              item: item,
              onDelete: (item) => _handleDelete(item, appBloc),
              dismissDirection: DismissDirection.endToStart,
              child: ListTile(
                title: Text(item.name),
                subtitle:
                    Text(Utils.dateformatWithYYYYMMDD(item.creatTimeStamp)),
                onTap: () {
                  bloc.stopHandel(0);
                  bloc.replaceHandel(item.metronomes);
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList();
          return ListView(
            children: widgets,
          );
        } else {
          return Container(
            height: Utils.getScreenHeight(context) / 2.0,
            child: Text('没有保存记录'),
          );
        }
      },
    );
  }
}
