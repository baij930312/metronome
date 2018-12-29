import 'package:flutter/material.dart';

enum AlertState {
  cancel,
  confirm,
}

class BottomToolBar extends StatelessWidget {
  const BottomToolBar({this.color, this.fabLocation, this.shape});

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;

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
        print('点击确认 ');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      IconButton(
        icon: const Icon(Icons.menu, semanticLabel: '不着急'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => const LocalStoreDrawer(),
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
          semanticLabel: '不着急',
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
      IconButton(
        icon: Icon(
          Icons.refresh,
          semanticLabel: '不着急',
        ),
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('不着急')),
          );
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
  const LocalStoreDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation),
            title: Text('3D'),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation),
            title: Text('3D'),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation),
            title: Text('3D'),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation),
            title: Text('3D'),
          ),
        ],
      ),
    );
  }
}
