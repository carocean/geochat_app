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
    final headerNotifier = createHeaderNotifier(scrollController);
    final footerNotifier = createFooterNotifier(scrollController);
    final userOffsetNotifier = ValueNotifier<bool>(false);
    _indicatorSettings = IndicatorSettings(
      scrollController: scrollController,
      headerNotifier: headerNotifier,
      footerNotifier: footerNotifier,
      userOffsetNotifier: userOffsetNotifier,
      scrollDirection: Axis.vertical,
    ).build(createScrollBehavior);

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @protected
  ScrollController createScrollController() {
    return ScrollController();
  }

  @protected
  HeaderNotifier createHeaderNotifier(ScrollController scrollController) {
    return HeaderNotifier();
  }

  @protected
  FooterNotifier createFooterNotifier(ScrollController scrollController) {
    return FooterNotifier();
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
          print("header::::${value.scrollState}");
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: value.reservePixels,
            child: Container(
              color: Colors.red,
              height: value.reservePixels,
            ),
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: indicatorSettings.headerNotifier.listenable(),
      builder: (BuildContext context, value, Widget? child) {
        return Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          width: value.reservePixels,
          child: Container(
            color: Colors.red,
            width: value.reservePixels,
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
          print("footer::::${value.scrollState}");
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: value.reservePixels,
            child: Container(
              color: Colors.red,
              height: value.reservePixels,
            ),
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: indicatorSettings.footerNotifier.listenable(),
      builder: (BuildContext context, value, Widget? child) {
        return Positioned(
          bottom: 0,
          right: 0,
          top: 0,
          width: value.reservePixels,
          child: Container(
            color: Colors.red,
            width: value.reservePixels,
          ),
        );
      },
    );
  }
}
