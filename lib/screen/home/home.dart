import 'package:flutter/material.dart';
import 'package:metronome/bloc/bloc_provider.dart';
import 'package:metronome/screen/home/metronome_tile.dart';
import 'package:metronome/screen/home/model/metronome_model.dart';
import 'package:metronome/screen/home/model/play_state.dart';
import 'package:metronome/screen/home/model/reorder_modeld.dart';
import 'package:metronome/widget/fade_appbar.dart';
import 'package:metronome/widget/backdrop_panel.dart';
import 'package:metronome/widget/bottom_tool_bar.dart';
import 'dart:math' as math;

import 'package:metronome/widget/drag_delete_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //索引backdrop 面板
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  //面板动画
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    //面板停在最下方 或者 面板正在想左下方移动
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  //面板高度
  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _toggleBackdropPanelVisibility() {
    //判断当前面板位置，向反方向执行动画
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    //如果正在动画  或者面板在最上方不处理
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

//primaryDelta 主轴方向的移动距离
    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;
    //拖动结束时 查看当前高度 是否达到面板的一半
    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  Widget _buildDot(bool special, bool hightlight) {
    if (special) {
      return Container(
        margin: EdgeInsets.only(left: 3.0),
        child: Material(
          child: Container(
            height: 10.0,
            width: 10.0,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
          ),
          color: hightlight ? Colors.orange : Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 3.0),
        child: Material(
          child: Container(
            height: 10.0,
            width: 10.0,
          ),
          color: hightlight ? Colors.orange : Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      );
    }
  }

  Widget _buildBackDropTitle(HomeBloc bloc) {
    return StreamBuilder<PlayState>(
      stream: bloc.playStateStream,
      builder: (BuildContext context, AsyncSnapshot<PlayState> snapshot) {
        if (snapshot.hasData) {
          PlayState stateModel = snapshot.data;
          List<Widget> widgets = [];
          for (var i = 0; i < stateModel.totelBeatsOfBar; i++) {
            widgets.add(_buildDot(
              i == stateModel.totelBeatsOfBar - 1,
              i == stateModel.currentBeatIndex,
            ));
          }
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: widgets,
                ),
                Container(
                  child: Text(
                      '${stateModel.currentBarIndex}/${stateModel.totelCountOfBar}'),
                  margin: EdgeInsets.only(
                      right: (_controller.status == AnimationStatus.completed ||
                              _controller.status == AnimationStatus.forward)
                          ? 0.0
                          : 70.0),
                )
              ],
            ),
          );
        } else {
          return Text(
            '带一波好节奏~',
            style: TextStyle(
              color: Colors.grey,
            ),
          );
        }
      },
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;
    //面板动画
    final Animation<RelativeRect> panelAnimation = _controller.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          panelTop - MediaQuery.of(context).padding.bottom,
          0.0,
          panelTop - panelSize.height,
        ),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );

    //位置调整
    void _onReorder(int oldIndex, int newIndex, HomeBloc bloc) {
      bloc.reOrderHandel(ReorderModel(
        oldIndex,
        newIndex,
      ));
    }

    //删除一条节奏
    void _handleDelete(MetronomeModel item, HomeBloc bloc) {
      bloc.deleteHandel(item);
    }

    final ThemeData theme = Theme.of(context);
    final List<Widget> backdropItems = [Map()].map<Widget>((category) {
      final bool selected = false;
      return Material(
        child: ListTile(
          // title: Text(category.title),
          selected: selected,
        ),
      );
    }).toList();
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    return Container(
      key: _backdropKey,
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          ListTileTheme(
            iconColor: theme.primaryIconTheme.color,
            textColor: theme.primaryTextTheme.title.color.withOpacity(0.6),
            selectedColor: theme.primaryTextTheme.title.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: backdropItems,
              ),
            ),
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: _buildBackDropTitle(bloc),
              child: StreamBuilder(
                stream: bloc.resource,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MetronomeModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Container(
                          child: Text(
                            '点击右下方按钮添加节奏~',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    final widgets = snapshot.data.map<Widget>((item) {
                      return DragDeleteTile<MetronomeModel>(
                        key: Key(item.index.toString()),
                        item: item,
                        onDelete: (item) => _handleDelete(item, bloc),
                        dismissDirection: DismissDirection.endToStart,
                        child: MetronmonTile(item),
                      );
                    }).toList();
                    return ReorderableListView(
                      children: widgets,
                      onReorder: (int oldIndex, int newIndex) => _onReorder(
                            oldIndex,
                            newIndex,
                            bloc,
                          ),
                      scrollDirection: Axis.vertical,
                    );
                  } else {
                    return Center(
                      child: Container(
                        child: Text(
                          '点击右下方按钮添加节奏~',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: BackdropTitle(
          listenable: _controller.view,
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: _toggleBackdropPanelVisibility,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              semanticLabel: 'close',
              progress: _controller.view,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomToolBar(
        shape: CircularNotchedRectangle(),
        fabLocation: FloatingActionButtonLocation.endDocked,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.addHandel(MetronomeModel(
            index: Utils.currentTimeMillis(),
            counts: 2,
            beatsOfBar: 4,
            beatsOfMinute: 60,
          ));
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
