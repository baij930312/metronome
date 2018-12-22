
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      IconButton(
        icon: const Icon(Icons.menu, semanticLabel: '不着急'),
        onPressed: () {},
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
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('不着急')),
          );
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
