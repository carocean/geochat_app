import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';
import 'package:uuid/uuid.dart';

import '_ballistic_indicator_views.dart';

///惯性布局;键盘上推；刷新指示器；抽屉；
abstract class BallisticIndicatorLayout<T extends StatefulWidget>
    extends State<T> with WidgetsBindingObserver {
  double _keyboardHeight = 0.0;
  bool? isPushContentWhenKeyboardShow;

  double get keyboardHeight => _keyboardHeight;

  late IndicatorSettings _indicatorSettings;

  IndicatorSettings get indicatorSettings => _indicatorSettings;
//保持住滚动的位置状态。必须设定它到scrollview，原因是：当改变stack内容和头脚的层次时会导致重绘，而重绘会使scrollview失去位置状态而反回到初始态0，这个问题很奇怪，并不是每次都会失去位置状态。
  //但为了万无一失，为滚动组件指定PageStorageKey
  late PageStorageKey _scrollViewKey;

  ///派生类的scrollview必须设置该key，否则在stack内容切换时滚动控件会回到原位
  PageStorageKey get scrollViewKey => _scrollViewKey;

  @override
  void initState() {
    _scrollViewKey=PageStorageKey(Uuid().toString());
    _indicatorSettings = IndicatorSettings();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
    if (indicatorSettings.headerSettings?.scrollMode ==
        IndicatorScrollMode.interact) {
      return _buildHeaderView();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _empty() {
    return const Positioned(child: SizedBox.shrink());
  }

  Widget _buildHeaderView() {
    if (indicatorSettings.scrollDirection == Axis.vertical) {
      return ValueListenableBuilder(
        valueListenable: indicatorSettings.headerNotifier.listenable(),
        builder: (BuildContext context, value, Widget? child) {
          value as HeaderNotifier;
          var pixels = value.position?.pixels ?? 0.0;
          if (pixels >= (value.position?.maxScrollExtent ?? 0.0)) {
            return _empty();
          }

          var builder = indicatorSettings.headerSettings?.buildChild;

          if ((value.expandPixels ?? 0) > value.reservePixels) {
            Widget childWidget;
            if (builder == null) {
              throw FlutterError('当expandPixels>reservePixels为抽屉模式，头不能为空.');
            }
            childWidget = builder(indicatorSettings.headerSettings, value,
                indicatorSettings.scrollDirection);
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: value.expandPixels,
              child: childWidget,
            );
          }

          var reservePixels = value.reservePixels;
          var height = max(reservePixels / 2, pixels.abs());

          Widget childWidget;
          if (builder != null) {
            childWidget = builder(indicatorSettings.headerSettings, value,
                indicatorSettings.scrollDirection);
          } else {
            childWidget = SimpleHeaderView(
              headerNotifier: value,
              headerSettings: indicatorSettings.headerSettings,
              scrollDirection: indicatorSettings.scrollDirection,
              textStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            );
          }
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: height,
            child: childWidget,
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: indicatorSettings.headerNotifier.listenable(),
      builder: (BuildContext context, value, Widget? child) {
        value as HeaderNotifier;
        var pixels = value.position?.pixels ?? 0.0;
        if (pixels >= (value.position?.maxScrollExtent ?? 0.0)) {
          return _empty();
        }

        var builder = indicatorSettings.headerSettings?.buildChild;

        if ((value.expandPixels ?? 0) > value.reservePixels) {
          Widget childWidget;
          if (builder == null) {
            throw FlutterError('当expandPixels>reservePixels为抽屉模式，头不能为空.');
          }
          childWidget = builder(indicatorSettings.headerSettings, value,
              indicatorSettings.scrollDirection);
          return Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            width: value.expandPixels,
            child: childWidget,
          );
        }

        var reservePixels = value.reservePixels;
        var width = max(reservePixels / 2, pixels.abs());

        Widget childWidget;
        if (builder != null) {
          childWidget = builder(indicatorSettings.headerSettings, value,
              indicatorSettings.scrollDirection);
        } else {
          childWidget = SimpleHeaderView(
            headerNotifier: value,
            headerSettings: indicatorSettings.headerSettings,
            scrollDirection: indicatorSettings.scrollDirection,
            textStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          );
        }
        return Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          width: width,
          child: childWidget,
        );
      },
    );
  }

  Widget buildFooterView() {
    if (indicatorSettings.footerSettings?.scrollMode ==
        IndicatorScrollMode.interact) {
      return _buildFooterView();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildFooterView() {
    if (indicatorSettings.scrollDirection == Axis.vertical) {
      return ValueListenableBuilder(
        valueListenable: indicatorSettings.footerNotifier.listenable(),
        builder: (BuildContext context, value, Widget? child) {
          value as FooterNotifier;
          var pixels = value.position?.pixels ?? 0.0;
          if (pixels <= 0) {
            return _empty();
          }

          var builder = indicatorSettings.footerSettings?.buildChild;

          if ((value.expandPixels ?? 0) > value.reservePixels) {
            Widget childWidget;
            if (builder == null) {
              throw FlutterError(
                  '当expandPixels>reservePixels为抽屉模式，footer不能为空.');
            }
            childWidget = builder(indicatorSettings.footerSettings, value,
                indicatorSettings.scrollDirection);
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: value.expandPixels,
              child: childWidget,
            );
          }

          var reservePixels = value.reservePixels;
          var maxScrollExtent = (value.position?.maxScrollExtent ?? 0.0).abs();
          var height =
              max(reservePixels / 2, (pixels.abs() - maxScrollExtent).abs());

          Widget childWidget;
          if (builder != null) {
            childWidget = builder(indicatorSettings.footerSettings, value,
                indicatorSettings.scrollDirection);
          } else {
            childWidget = SimpleFooterView(
              scrollDirection: indicatorSettings.scrollDirection,
              footerSettings: indicatorSettings.footerSettings,
              footerNotifier: indicatorSettings.footerNotifier,
              textStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            );
          }
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: height,
            child: childWidget,
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: indicatorSettings.footerNotifier.listenable(),
      builder: (BuildContext context, value, Widget? child) {
        value as FooterNotifier;
        var pixels = value.position?.pixels ?? 0.0;
        if (pixels <= 0) {
          return _empty();
        }

        var builder = indicatorSettings.footerSettings?.buildChild;

        if ((value.expandPixels ?? 0) > value.reservePixels) {
          Widget childWidget;
          if (builder == null) {
            throw FlutterError('当expandPixels>reservePixels为抽屉模式，footer不能为空.');
          }
          childWidget = builder(indicatorSettings.footerSettings, value,
              indicatorSettings.scrollDirection);
          return Positioned(
            bottom: 0,
            right: 0,
            top: 0,
            width: value.expandPixels,
            child: Container(
              child: childWidget,
            ),
          );
        }
        var reservePixels = value.reservePixels;
        var width = max(reservePixels / 2, pixels.abs());
        Widget childWidget;
        if (builder != null) {
          childWidget = builder(indicatorSettings.footerSettings, value,
              indicatorSettings.scrollDirection);
        } else {
          childWidget = SimpleFooterView(
            scrollDirection: indicatorSettings.scrollDirection,
            footerSettings: indicatorSettings.footerSettings,
            footerNotifier: indicatorSettings.footerNotifier,
            textStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          );
        }
        return Positioned(
          bottom: 0,
          right: 0,
          top: 0,
          width: width,
          child: Container(
            child: childWidget,
          ),
        );
      },
    );
  }
}
