/// 封装以下flutter组件改为弹性组件
/// SingleChildScrollView, which is a scrollable widget that has a single child.
/// ListView, which is a commonly used ScrollView that displays a scrolling, linear list of child widgets.
/// GridView, which is a ScrollView that displays a scrolling, 2D array of child widgets.
/// PageView, which is a scrolling list of child widgets that are each the size of the viewport.
/// CustomScrollView, which is a ScrollView that creates custom scroll effects using slivers.
/// NestedScrollView solves this problem by providing custom
/// ScrollNotification and NotificationListener, which can be used to watch the scroll position without using a ScrollController.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///惯性布局,需自己实现布局规则；键盘弹出上推；
abstract class BallisticLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  double _keyboardHeight = 0.0;
  late ScrollController _scrollController;
  bool? isPushContentWhenKeyboardShow;

  double get keyboardHeight => _keyboardHeight;

  ScrollController get scrollController => _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!(isPushContentWhenKeyboardShow ?? false)) {
      return;
    }
    //对于非sliver组件只能用此计算高度，sliver组件则采用另外一套机制：SliverLayoutBuilder。这是因为LayoutBuilder中的约束不能得到组件可绘高度
    // 键盘高度
    final double viewInsetsBottom = EdgeInsets.fromWindowPadding(
            WidgetsBinding.instance.window.viewInsets,
            WidgetsBinding.instance.window.devicePixelRatio)
        .bottom;

    // if (kDebugMode) {
    //   print(viewInsetsBottom);
    // }

    if (mounted) {
      setState(() {
        _keyboardHeight = viewInsetsBottom;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          //build完成后的回调
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent, //滚动到底部
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  double scrollViewHeight(AppBar? appBar, {BuildContext? parentContext}) {
    return scrollViewHeightBy(appBar?.preferredSize.height);
  }

  ///这里除去了状态栏、和键盘，但如有标题栏和底部导航栏则要除去。
  double scrollViewHeightBy(double? size, {BuildContext? parentContext}) {
    var context = parentContext ?? this.context;
    size ??= 0.0;
    var scrollViewHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        size -
        _keyboardHeight;
    return scrollViewHeight;
  }
}

///惯性布局,需自己实现布局规则；键盘弹出上推；透明度；
abstract class BallisticSliverLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  bool? isPushContentWhenKeyboardShow;

  ScrollController get scrollController => _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!(isPushContentWhenKeyboardShow ?? false)) {
      return;
    }

    if (mounted) {
      setState(() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          //build完成后的回调
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent, //滚动到底部
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }
}
