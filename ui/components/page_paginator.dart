import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../core/resources/themes.dart';
import 'adaptive_progress_indicator.dart';

class PaginatorPage<T> extends StatefulWidget {
  ///A function that returns a `List` of the specified type, utilizing the `page` and `limit` parameters for pagination.
  final int limit;

  ///A flag indicating whether the list supports pagination. If set to `false`, the list will not load more items when scrolled to the bottom.
  final bool paginated;

  ///A list of widgets displayed before the paginated data items, useful for adding headers or introductory content.
  final List<Widget> prefixChildren;

  ///A function that returns a `List` of the specified type, utilizing the `page` and `limit` parameters for pagination.
  final Future<List<T>> Function(int page, int limit) future;

  ///A builder function for customizing each list item. It provides access to `index` and `T item`, allowing you to fully customize the UI for each data entry.
  final Widget Function(int index, T item, RefreshController refreshController) itemBuilder;

  ///A widget builder displayed when the list contains no data.
  final Widget Function(BuildContext context, RefreshController refreshController)? emptyBuilder;

  ///A widget builder displayed during the initial loading process or when a refresh is triggered.
  final Widget Function(BuildContext context, RefreshController refreshController)? loadingBuilder;

  ///Configures padding around the list for proper spacing and layout.
  final EdgeInsets? padding;

  final RefreshController? refreshController;

  /// A versatile class to handle API pagination with ease.
  ///
  /// - `future`: A function that returns a `List` of the specified type, utilizing the `page` and `limit` parameters for pagination.
  /// - `itemBuilder`: A builder function for customizing each list item. It provides access to `index` and `T item`, allowing you to fully customize the UI for each data entry.
  /// - `emptyBuilder`: A widget builder displayed when the list contains no data.
  /// - `loadingBuilder`: A widget builder displayed during the initial loading process or when a refresh is triggered.
  /// - `limit`: Specifies the maximum number of items per page. This value is passed to the `future` function for pagination.
  /// - `prefixChildren`: A list of widgets displayed before the paginated data items, useful for adding headers or introductory content.
  /// - `padding`: Configures padding around the list for proper spacing and layout.
  /// - `paginated`: A flag indicating whether the list supports pagination. If set to `false`, the list will not load more items when scrolled to the bottom.
  /// - `refreshController`: A controller used to manage refresh and load-more actions, ensuring seamless user interactions and API requests.
  const PaginatorPage({
    super.key,
    required this.future,
    required this.itemBuilder,
    this.refreshController,
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
  late RefreshController refreshController;

  @override
  void initState() {
    refreshController = widget.refreshController ?? RefreshController();
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
      body = widget.loadingBuilder!.call(context, refreshController);
    }

    if (!loading) {
      if (data.isEmpty) {
        if (widget.emptyBuilder != null) {
          body = widget.emptyBuilder!.call(context, refreshController);
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
            ...List.generate(data.length, (index) => widget.itemBuilder.call(index, data[index], refreshController)),
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
