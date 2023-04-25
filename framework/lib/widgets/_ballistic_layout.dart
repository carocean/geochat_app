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
import 'package:uuid/uuid.dart';

///惯性布局,需自己实现布局规则；键盘弹出上推；
abstract class BallisticLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  late ScrollController? _scrollController;
  bool? isPushContentWhenKeyboardShow;
//保持住滚动的位置状态。必须设定它到scrollview，原因是：当改变stack内容和头脚的层次时会导致重绘，而重绘会使scrollview失去位置状态而反回到初始态0，这个问题很奇怪，并不是每次都会失去位置状态。
  //但为了万无一失，为滚动组件指定PageStorageKey
  late PageStorageKey _scrollViewKey;

  ///派生类的scrollview必须设置该key，否则在stack内容切换时滚动控件会回到原位
  PageStorageKey get scrollViewKey => _scrollViewKey;
  ScrollController? get scrollController => _scrollController;

  @override
  void initState() {
    _scrollViewKey=PageStorageKey(const Uuid().toString());
    _scrollController = createScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @protected
  ScrollController createScrollController() {
    return ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
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

    if (viewInsetsBottom > 0) {
      _scrollController?.animateTo(
        _scrollController!.position.maxScrollExtent, //滚动到底部
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

///惯性布局,需自己实现布局规则；键盘弹出上推；透明度；
abstract class BallisticSliverLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  bool? isPushContentWhenKeyboardShow;
//保持住滚动的位置状态。必须设定它到scrollview，原因是：当改变stack内容和头脚的层次时会导致重绘，而重绘会使scrollview失去位置状态而反回到初始态0，这个问题很奇怪，并不是每次都会失去位置状态。
  //但为了万无一失，为滚动组件指定PageStorageKey
  late PageStorageKey _scrollViewKey;

  ///派生类的scrollview必须设置该key，否则在stack内容切换时滚动控件会回到原位
  PageStorageKey get scrollViewKey => _scrollViewKey;
  ScrollController get scrollController => _scrollController;

  @override
  void initState() {
    _scrollViewKey=PageStorageKey(const Uuid().toString());
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

    if (viewInsetsBottom > 0) {
      _scrollController?.animateTo(
        _scrollController!.position.maxScrollExtent, //滚动到底部
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
