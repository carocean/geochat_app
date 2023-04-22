import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';

import '_ballistic_indicator_views.dart';

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
  Widget _empty(){
    return const Positioned(child: SizedBox.shrink());
  }
  Widget _buildHeaderView() {
    if (indicatorSettings.scrollDirection == Axis.vertical) {
      return ValueListenableBuilder(
        valueListenable: indicatorSettings.headerNotifier.listenable(),
        builder: (BuildContext context, value, Widget? child) {
          value as HeaderNotifier;
          var pixels = value.position?.pixels ?? 0.0;
          if(pixels>=(value.position?.maxScrollExtent??0.0)){
            return _empty();
          }
          var reservePixels = value.reservePixels;
          var height = max(reservePixels / 2, pixels.abs());
          var builder = indicatorSettings.headerSettings?.buildChild;
          Widget childWidget;
          if (builder != null) {
            childWidget = builder(indicatorSettings.headerSettings, value,indicatorSettings.scrollDirection);
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
        if(pixels>=(value.position?.maxScrollExtent??0.0)){
          return _empty();
        }
        var reservePixels = value.reservePixels;
        var width = max(reservePixels / 2, pixels.abs());

        var builder = indicatorSettings.headerSettings?.buildChild;
        Widget childWidget;
        if (builder != null) {
          childWidget = builder(indicatorSettings.headerSettings, value,indicatorSettings.scrollDirection);
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
          if(pixels<=0) {
            return _empty();
          }
          var reservePixels = value.reservePixels;
          var maxScrollExtent = (value.position?.maxScrollExtent ?? 0.0).abs();
          var height =
              max(reservePixels / 2, (pixels.abs() - maxScrollExtent).abs());

          var builder = indicatorSettings.footerSettings?.buildChild;
          Widget childWidget;
          if (builder != null) {
            childWidget = builder(indicatorSettings.footerSettings, value,indicatorSettings.scrollDirection);
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
        if(pixels<=0) {
          return _empty();
        }
        var reservePixels = value.reservePixels;
        var width = max(reservePixels / 2, pixels.abs());
        var builder = indicatorSettings.footerSettings?.buildChild;
        Widget childWidget;
        if (builder != null) {
          childWidget = builder(indicatorSettings.footerSettings, value,indicatorSettings.scrollDirection);
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
