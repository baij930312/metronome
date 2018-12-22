import 'package:flutter/material.dart';

//放置节奏item的面板
class BackdropPanel extends StatelessWidget {
  const BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap; //点击事件
  final GestureDragUpdateCallback onVerticalDragUpdate; //收拾上拉更新事件
  final GestureDragEndCallback onVerticalDragEnd; //上啦时候是结束事件
  final Widget title; //标题
  final Widget child; //内容

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); //主题
    return Material(
      //圆角
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //手势
          GestureDetector(
            //表明当前 widget接受事件 并且不想后穿透
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: theme.textTheme.subhead,
                child: Tooltip(
                  message: 'Tap to dismiss',
                  child: title, //把title组件内嵌进来添加组件
                ),
              ),
            ),
          ),
          const Divider(height: 1.0),
          Expanded(child: child),
        ],
      ),
    );
  }
}
