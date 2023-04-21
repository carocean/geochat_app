import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:framework/widgets/_ballistic_indicator_scroll_behavior_physics.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';

///惯性布局;键盘上推；刷新指示器；抽屉；
abstract class BallisticIndicatorLayout<T extends StatefulWidget>
    extends State<T> with WidgetsBindingObserver {
  double _keyboardHeight = 0.0;
  bool? isPushContentWhenKeyboardShow;

  double get keyboardHeight => _keyboardHeight;

  late IndicatorSettings _indicatorSettings;

  IndicatorSettings get indicatorSettings => _indicatorSettings;

  @override
  void initState() {
    final scrollController = createScrollController();
    final userOffsetNotifier = ValueNotifier<bool>(false);
    final headerNotifier =
        createHeaderNotifier(scrollController, userOffsetNotifier);
    final footerNotifier =
        createFooterNotifier(scrollController, userOffsetNotifier);
    _indicatorSettings = IndicatorSettings(
      scrollController: scrollController,
      headerNotifier: headerNotifier,
      footerNotifier: footerNotifier,
      userOffsetNotifier: userOffsetNotifier,
      scrollDirection: Axis.vertical,
    ).bindScrollBehavior(createScrollBehavior);

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @protected
  ScrollController createScrollController() {
    return ScrollController();
  }

  @protected
  HeaderNotifier createHeaderNotifier(ScrollController scrollController,
      ValueNotifier<bool> userOffsetNotifier) {
    return HeaderNotifier(
        scrollController: scrollController,
        userOffsetNotifier: userOffsetNotifier);
  }

  @protected
  FooterNotifier createFooterNotifier(ScrollController scrollController,
      ValueNotifier<bool> userOffsetNotifier) {
    return FooterNotifier(
        scrollController: scrollController,
        userOffsetNotifier: userOffsetNotifier);
  }

  @protected
  ScrollBehavior createScrollBehavior(settings) {
    var scrollPhysices = IndicatorScrollPhysics(
      headerNotifier: settings.headerNotifier,
      footerNotifier: settings.footerNotifier,
      userOffsetNotifier: settings.userOffsetNotifier,
    );
    return IndicatorScrollBehavior(scrollPhysices);
  }

  @override
  void dispose() {
    _indicatorSettings.dispose();
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
          var scrollController = _indicatorSettings.scrollController;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            //滚动到底部
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  ///这里除去了状态栏、和键盘，但如有标题栏和底部导航栏则要除去。
  double scrollViewHeight(double? appBarHeight, double? navBarHeight,
      {BuildContext? parentContext}) {
    var context = parentContext ?? this.context;
    appBarHeight ??= 0.0;
    navBarHeight ??= 0.0;
    var scrollViewHeight = 0.0;
    if (appBarHeight > 0) {
      //有标题栏 说明context获取的高度是内容区的高度，非整屏
      if (_keyboardHeight > 0) {
        //弹出了键盘
        scrollViewHeight = (MediaQuery.of(context).size.height + navBarHeight) -
            _keyboardHeight;
      } else {
        //没弹出键盘
        scrollViewHeight = MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            appBarHeight -
            navBarHeight;
      }
      return scrollViewHeight;
    }
    //其下是没有标题栏，即context是全屏
    scrollViewHeight = (MediaQuery.of(context).size.height + 50) -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        appBarHeight -
        navBarHeight -
        _keyboardHeight;

    return scrollViewHeight;
  }

  Widget buildHeaderView() {
    if (indicatorSettings.scrollDirection == Axis.vertical) {
      return ValueListenableBuilder(
        valueListenable: indicatorSettings.headerNotifier.listenable(),
        builder: (BuildContext context, value, Widget? child) {
          value as HeaderNotifier;
          var pixels = value.position?.pixels ?? 0.0;
          var reservePixels = value.reservePixels;
          var height = max(reservePixels / 2, pixels.abs());
          var tips = '';
          switch (value.scrollState) {
            case ScrollState.underScrolling:
              tips = '边界滑动..';
              break;
            case ScrollState.underScrollEnd:
              tips = '达到边界';
              break;
            case ScrollState.underScrollRefreshing:
              tips = '正在刷新..';
              break;
            case ScrollState.underScrollRefreshDone:
              tips = '完成刷新';
              break;
            case ScrollState.underScrollCollapsing:
              tips = '正在收起...';
              break;
            case ScrollState.underScrollCollapseDone:
              tips = '处理完毕';
              break;
            case ScrollState.sliding:
              tips = '正在滑动..';
              break;
            default:
              tips = '...';
              break;
          }
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: height,
            child: indicatorSettings.headerSettings?.child ??
                Center(
                  child: Text(
                    tips,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: indicatorSettings.headerNotifier.listenable(),
      builder: (BuildContext context, value, Widget? child) {
        value as HeaderNotifier;
        var pixels = value.position?.pixels ?? 0.0;
        var reservePixels = value.reservePixels;
        var width = max(reservePixels / 2, pixels.abs());
        var tips = '';
        switch (value.scrollState) {
          case ScrollState.underScrolling:
            tips = '边界滑动..';
            break;
          case ScrollState.underScrollEnd:
            tips = '达到边界';
            break;
          case ScrollState.underScrollRefreshing:
            tips = '正在刷新..';
            break;
          case ScrollState.underScrollRefreshDone:
            tips = '完成刷新';
            break;
          case ScrollState.underScrollCollapsing:
            tips = '正在收起...';
            break;
          case ScrollState.underScrollCollapseDone:
            tips = '处理完毕';
            break;
          case ScrollState.sliding:
            tips = '正在滑动..';
            break;
          default:
            tips = '...';
            break;
        }
        return Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          width: width,
          child: indicatorSettings.headerSettings?.child ??
              Center(
                child: SizedBox(
                  width: 10,
                  child: Text(
                    tips,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }

  Widget buildFooterView() {
    if (indicatorSettings.scrollDirection == Axis.vertical) {
      return ValueListenableBuilder(
        valueListenable: indicatorSettings.footerNotifier.listenable(),
        builder: (BuildContext context, value, Widget? child) {
          value as FooterNotifier;
          var pixels = value.position?.pixels ?? 0.0;
          var reservePixels = value.reservePixels;
          var maxScrollExtent = (value.position?.maxScrollExtent ?? 0.0).abs();
          var height =
              max(reservePixels / 2, (pixels.abs() - maxScrollExtent).abs());
          var tips = '';
          switch (value.scrollState) {
            case ScrollState.overScrolling:
              tips = '边界滑动..';
              break;
            case ScrollState.overScrollEnd:
              tips = '达到边界';
              break;
            case ScrollState.overScrollLoading:
              tips = '正在装载...';
              break;
            case ScrollState.overScrollLoadDone:
              tips = '完成装载';
              break;
            case ScrollState.overScrollCollapsing:
              tips = '正在收起...';
              break;
            case ScrollState.overScrollCollapseDone:
              tips = '处理完毕';
              break;
            case ScrollState.sliding:
              tips = '正在滑动..';
              break;
            default:
              tips = '...';
              break;
          }
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: height,
            child: indicatorSettings.footerSettings?.child ??
                Center(
                  child: Text(
                    tips,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: indicatorSettings.footerNotifier.listenable(),
      builder: (BuildContext context, value, Widget? child) {
        value as FooterNotifier;
        var pixels = value.position?.pixels ?? 0.0;
        var reservePixels = value.reservePixels;
        var width = max(reservePixels / 2, pixels.abs());
        var tips = '';
        switch (value.scrollState) {
          case ScrollState.overScrolling:
            tips = '边界滑动..';
            break;
          case ScrollState.overScrollEnd:
            tips = '达到边界';
            break;
          case ScrollState.overScrollLoading:
            tips = '正在装载...';
            break;
          case ScrollState.overScrollLoadDone:
            tips = '完成装载';
            break;
          case ScrollState.overScrollCollapsing:
            tips = '正在收起...';
            break;
          case ScrollState.overScrollCollapseDone:
            tips = '处理完毕';
            break;
          case ScrollState.sliding:
            tips = '正在滑动..';
            break;
          default:
            tips = '...';
            break;
        }
        return Positioned(
          bottom: 0,
          right: 0,
          top: 0,
          width: width,
          child: Container(
            child: indicatorSettings.footerSettings?.child ??
                Center(
                  child: SizedBox(
                    width: 12,
                    child: Text(
                      tips,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }
}
