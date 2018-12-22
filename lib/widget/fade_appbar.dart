import 'package:flutter/material.dart';

class BackdropTitle extends AnimatedWidget {
  const BackdropTitle({
    Key key,
    Listenable listenable,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    //创建一个默认text样式 向下传递
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      //不折行
      softWrap: false,
      //当文字超出时默认打点
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('设置'),
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Interval(0.5, 1.0),
            ).value,
            child: const Text('节奏'),
          ),
        ],
      ),
    );
  }
}