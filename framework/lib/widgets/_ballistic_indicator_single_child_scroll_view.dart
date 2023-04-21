import 'package:flutter/material.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';

import '_ballistic_indicator_layout.dart';
import '_opacity_listener.dart';

class BallisticIndicatorSingleChildScrollView extends StatefulWidget {
  final BuildContext parentContext;
  ScrollController? scrollController;
  Widget display;
  List<Positioned>? positioneds;
  OpacityListener? opacityListener;
  HeaderSettings? headerSettings;
  FooterSettings? footerSettings;

  ///标题栏高度
  double? appBarHeight;

  ///低部导航栏高度
  double? navBarHeight;

  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;
  Axis? scrollDirection;

  BallisticIndicatorSingleChildScrollView({
    Key? key,
    required this.parentContext,
    this.scrollController,
    this.appBarHeight,
    this.navBarHeight,
    required this.display,
    this.scrollDirection,
    this.positioneds = const <Positioned>[],
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
    this.headerSettings,
    this.footerSettings,
  }) : super(key: key);

  @override
  State<BallisticIndicatorSingleChildScrollView> createState() =>
      _BallisticIndicatorSingleChildScrollViewState();
}

class _BallisticIndicatorSingleChildScrollViewState
    extends BallisticIndicatorLayout<BallisticIndicatorSingleChildScrollView> {
  @override
  void initState() {
    super.initState();
    indicatorSettings
        .bindHeaderSettings(widget.headerSettings)
        .bindFooterSettings(widget.footerSettings)
        .bindScrollDirection(widget.scrollDirection)
        .build(widget.scrollController);

    super.isPushContentWhenKeyboardShow = widget.isPushContentWhenKeyboardShow;
    widget.opacityListener
        ?.setScrollController(indicatorSettings.scrollController);
  }

  @override
  void dispose() {
    widget.opacityListener?.removeScrollController();
    super.dispose();
  }

  @override
  void didUpdateWidget(BallisticIndicatorSingleChildScrollView oldWidget) {
    if (oldWidget.appBarHeight != widget.appBarHeight) {
      oldWidget.appBarHeight = widget.appBarHeight;
    }
    if (oldWidget.headerSettings == widget.headerSettings) {
      oldWidget.headerSettings = widget.headerSettings;
    }
    if (oldWidget.footerSettings == widget.footerSettings) {
      oldWidget.footerSettings = widget.footerSettings;
    }
    if (widget.headerSettings != null &&
        !widget.headerSettings!.equalsTo(indicatorSettings.headerSettings)) {
      indicatorSettings.updateHeaderSettings(widget.headerSettings);
    }
    if (widget.footerSettings != null &&
        !widget.footerSettings!.equalsTo(indicatorSettings.footerSettings)) {
      indicatorSettings.updateFooterSettings(widget.footerSettings);
    }
    if (oldWidget.display != widget.display) {
      oldWidget.display = widget.display;
    }
    if (oldWidget.scrollDirection != widget.scrollDirection) {
      oldWidget.scrollDirection = widget.scrollDirection;
      indicatorSettings.updateScrollDirection(widget.scrollDirection);
    }
    if (oldWidget.positioneds != widget.positioneds ||
        oldWidget.positioneds!.length != widget.positioneds!.length) {
      oldWidget.positioneds = widget.positioneds;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    Widget content = buildContent();
    Widget header = buildHeaderView();
    Widget footer = buildFooterView();
    children.add(header);
    children.add(footer);
    children.add(content);
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.passthrough,
        children: children,
      ),
    );
  }

  Widget buildContent() {
    var child = ScrollConfiguration(
      behavior: indicatorSettings.scrollBehavior,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: indicatorSettings.scrollDirection,
          controller: indicatorSettings.scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: scrollViewHeight(
                  widget.appBarHeight ?? 96, widget.navBarHeight ?? 50,
                  parentContext: widget.parentContext),
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                widget.display,
                ...widget.positioneds ?? [],
              ],
            ),
          ),
        ),
      ),
    );
    return IndicatorInheritedWidget(
      indicatorSettings: indicatorSettings,
      child: child,
    );
  }
}
