import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../core/resources/themes.dart';
import 'adaptive_progress_indicator.dart';

class PaginatorPage<T> extends StatefulWidget {
  final int limit;
  final bool paginated;
  final List<Widget> prefixChildren;
  final Future<List<T>> Function(int page, int limit) future;
  final Widget Function(int index, T item) itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final EdgeInsets? padding;

  ///Magic class to paginate every api
  ///
  ///`future` = return as List of Type, with builder for the pagination `page` and `limit`
  ///
  ///`limit` = it will pass to `future` as `limit`
  ///
  ///`prefixChildren` = List of widget that will shows and included before items of data
  ///
  ///`padding` = Set list padding
  const PaginatorPage({
    super.key,
    required this.future,
    required this.itemBuilder,
    this.paginated = true,
    this.prefixChildren = const [],
    this.limit = 10,
    this.padding,
    this.emptyBuilder,
    this.loadingBuilder,
  });

  @override
  State<PaginatorPage<T>> createState() => PaginatorPageState<T>();
}

class PaginatorPageState<T> extends State<PaginatorPage<T>> with AutomaticKeepAliveClientMixin {
  final List<T> data = [];
  int _page = 1;
  bool loading = true;
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    loadData(true);
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget body = ListView(
      padding: widget.padding ?? EdgeInsets.all(10).copyWith(bottom: 120),
      children: [
        ...widget.prefixChildren,
        Container(height: 300, alignment: Alignment.center, child: AdaptiveProgressIndicator()),
      ],
    );

    if (widget.loadingBuilder != null && loading) {
      body = widget.loadingBuilder!.call(context);
    }

    if (!loading) {
      if (data.isEmpty) {
        if (widget.emptyBuilder != null) {
          body = widget.emptyBuilder!.call(context);
        } else {
          body = SingleChildScrollView(
            padding: widget.padding ?? EdgeInsets.all(10).copyWith(bottom: 120),
            child: Container(
              height: 300,
              alignment: Alignment.center,
              child: Text("There is no data"),
            ),
          );
        }
      } else {
        body = ListView(
          padding: widget.padding ?? EdgeInsets.all(10).copyWith(bottom: 120),
          children: [
            ...widget.prefixChildren,
            ...List.generate(data.length, (index) => widget.itemBuilder.call(index, data[index])),
          ],
        );
      }
    }
    return Container(
      color: theme(context).scaffoldBackgroundColor,
      child: SmartRefresher(
        controller: refreshController,
        onLoading: loadData,
        onRefresh: () => loadData(true),
        enablePullUp: widget.paginated,
        child: body,
      ),
    );
  }

  ///Data loader that do the magic
  void loadData([bool refresh = false]) async {
    if (refresh) {
      _page = 0;
      refreshController.resetNoData();
      data.clear();
      loading = true;
      setState(() {});
    }
    _page++;
    refreshController.refreshCompleted();
    var resp = await widget.future.call(_page, widget.limit);
    refreshController.loadComplete();
    loading = false;

    if (mounted) {
      setState(() {
        if (resp.isNotEmpty) {
          data.addAll(resp);
        } else {
          refreshController.loadNoData();
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
