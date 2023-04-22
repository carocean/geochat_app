import 'package:flutter/material.dart';

import '_ballistic_custom_scroll_view.dart';
import '_ballistic_indicator_layout.dart';
import '_ballistic_indicator_ultimate.dart';
import '_opacity_listener.dart';

class BallisticIndicatorNestedScrollView extends StatefulWidget {
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

  BallisticIndicatorNestedScrollView({
    Key? key,
    required this.parentContext,
    this.scrollController,
    required this.display,
    this.upDisplay,
    this.appBar,
    this.persistentHeader,
    this.scrollDirection,
    this.navBarHeight,
    this.positioneds = const <Positioned>[],
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
    this.headerSettings,
    this.footerSettings,
  }) : super(key: key);

  @override
  State<BallisticIndicatorNestedScrollView> createState() =>
      _BallisticIndicatorNestedScrollViewState();
}

class _BallisticIndicatorNestedScrollViewState
    extends BallisticIndicatorLayout<BallisticIndicatorNestedScrollView> {
  ScrollController? _nestedScrollController;

  @override
  void initState() {
    super.initState();
    indicatorSettings
        .bindHeaderSettings(widget.headerSettings)
        .bindFooterSettings(widget.footerSettings)
        .bindScrollDirection(widget.scrollDirection)
        .build(widget.scrollController);
    _nestedScrollController = ScrollController();
    indicatorSettings.scrollController.addListener(() {
      //内容不足屏时有冲突，没容出屏时正常，当上拉加载时整屏上移了，导致内容区域变化，下边界触不到，一种可设高上边界，一种可在此设置手热触摸才上滚：indicatorSettings.userOffsetNotifier
      ///触不到下边界的原因是：当到顶时触发了下面的jumpTo又回去，所以界触失效，如果内容满是没此问题的。如果在吸顶后不再执行jumpTo也可以，但再下拉时如何判断
      _nestedScrollController
          ?.jumpTo(indicatorSettings.scrollController.offset);
    });
    super.isPushContentWhenKeyboardShow = widget.isPushContentWhenKeyboardShow;
    widget.opacityListener
        ?.setScrollController(indicatorSettings.scrollController);
  }

  @override
  void dispose() {
    _nestedScrollController?.dispose();
    widget.opacityListener?.removeScrollController();
    super.dispose();
  }

  @override
  void didUpdateWidget(BallisticIndicatorNestedScrollView oldWidget) {
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
    return SizedBox.expand(
      child: NestedScrollView(
        controller: _nestedScrollController,
        scrollDirection: indicatorSettings.scrollDirection,
        headerSliverBuilder: (context, v) {
          var slivers = <Widget>[
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
          ];
          return slivers;
        },
        body: _renderBody(),
      ),
    );
  }

  Widget _renderBody() {
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
              minHeight: scrollViewHeight(widget.appBar?.collapsedHeight ?? 24,
                  widget.navBarHeight ?? 0.0,
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
