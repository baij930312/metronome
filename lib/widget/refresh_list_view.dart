import 'package:flutter/material.dart';

class RefreshResouceModel<T> {
  int page = 0; //页数
  List<T> list = []; //数据集合
  bool noMoreData = false; //是否还有数据
}

enum FetchDataType {
  loadmore,
  refresh,
}

typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T model, int index);

typedef FetchData = Function(FetchDataType type);

class RefreshListView<T> extends StatelessWidget {
  final TrackingScrollController _scrollController = TrackingScrollController();
  final Stream<RefreshResouceModel<T>> resource;
  final FetchData fetchData;
  final ItemBuilder<T> itemBuild;

  RefreshListView({
    @required this.resource,
    @required this.itemBuild,
    @required this.fetchData,
  }) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //load more
        this.fetchData(FetchDataType.loadmore);
      }
    });
    this.fetchData(FetchDataType.refresh);
  }

  // stream
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => this.fetchData(FetchDataType.refresh),
      child: StreamBuilder(
        stream: this.resource,
        builder: (BuildContext context,
            AsyncSnapshot<RefreshResouceModel<T>> snapshot) {
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: snapshot.hasData ? snapshot.data.list.length + 1 : 0,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.data.list.length == index) {
                return Container(
                  height: 100.0,
                  child: Center(
                    child: snapshot.data.noMoreData
                        ? Text('已经没有数据了')
                        : Text('正在加载...'),
                  ),
                );
              }
              return this.itemBuild(
                context,
                snapshot.data.list[index],
                index,
              );
            },
          );
        },
      ),
    );
  }
}
