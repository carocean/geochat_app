import 'package:flutter/material.dart';

import '_ballistic_custom_scroll_view.dart';
import '_ballistic_indicator_layout.dart';
import '_ballistic_indicator_ultimate.dart';
import '_opacity_listener.dart';

class BallisticIndicatorCustomScrollView extends StatefulWidget {
  final BuildContext parentContext;
  ScrollController? scrollController;
  Widget display;
  List<Positioned>? positioneds;
  OpacityListener? opacityListener;
  HeaderSettings? headerSettings;
  FooterSettings? footerSettings;
  SliverAppBar? appBar;
  Widget? upDisplay;
  ///低部导航栏高度
  double? navBarHeight;
  final BallisticSliverPersistentHeader? persistentHeader;


  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;
  Axis? scrollDirection;

  BallisticIndicatorCustomScrollView({
    Key? key,
    required this.parentContext,
    this.scrollController,
    required this.display,
    this.upDisplay,
    this.appBar,
    this.persistentHeader,
    this.navBarHeight,
    this.scrollDirection,
    this.positioneds = const <Positioned>[],
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
    this.headerSettings,
    this.footerSettings,
  }) : super(key: key);
  @override
  State<BallisticIndicatorCustomScrollView> createState() => _BallisticIndicatorCustomScrollViewState();
}

class _BallisticIndicatorCustomScrollViewState extends BallisticIndicatorLayout<BallisticIndicatorCustomScrollView> {
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
  void didUpdateWidget(BallisticIndicatorCustomScrollView oldWidget) {
    if (oldWidget.appBar != widget.appBar) {
      oldWidget.appBar = widget.appBar;
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
        child: CustomScrollView(
          scrollDirection: indicatorSettings.scrollDirection,
          controller: indicatorSettings.scrollController,
          slivers: [
            widget.appBar ??
                const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
            SliverToBoxAdapter(
              child: widget.upDisplay ?? const SizedBox.shrink(),
            ),
            widget.persistentHeader == null
                ? const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
                : SliverPersistentHeader(
              delegate: BallisticSliverPersistentHeaderDelegate(
                buildPersistentHeader:
                widget.persistentHeader!.buildPersistentHeader,
                maxExtent: widget.persistentHeader!.maxExtent,
                minExtent: widget.persistentHeader!.minExtent,
              ),
              floating: widget.persistentHeader!.floating ?? false,
              pinned: widget.persistentHeader!.pinned ?? true,
            ),
            SliverLayoutBuilder(
              builder: (cxt, constraints) {
                return SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.remainingPaintExtent,
                      // maxHeight: height,
                    ),
                    child: Stack(
                      // Center is a layout widget. It takes a single child and positions it
                      // in the middle of the parent.
                      fit: StackFit.passthrough,
                      children: [
                        widget.display,
                        ...widget.positioneds!,
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
    return IndicatorInheritedWidget(
      indicatorSettings: indicatorSettings,
      child: child,
    );
  }
}
