import 'package:flutter/material.dart';

import '_ballistic_layout.dart';
import '_opacity_listener.dart';

typedef BuildPersistentHeader = Widget Function(
  BuildContext context,
  double shrinkOffset,
  bool overlapsContent,
  double minExtent,
  double maxExtent,
);

class BallisticCustomScrollView extends StatefulWidget {
  SliverAppBar? appBar;
  Widget? upDisplay;
  final BallisticSliverPersistentHeader? persistentHeader;
  Widget display;
  List<Positioned>? positioneds;
  final OpacityListener? opacityListener;

  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;

  BallisticCustomScrollView({
    Key? key,
    this.appBar,
    this.upDisplay,
    this.persistentHeader,
    required this.display,
    this.positioneds,
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
  }) : super(key: key) {
    positioneds ??= [];
  }

  @override
  State<BallisticCustomScrollView> createState() =>
      _BallisticCustomScrollViewState();
}

class _BallisticCustomScrollViewState
    extends BallisticSliverLayout<BallisticCustomScrollView> {
  @override
  void initState() {
    super.initState();
    super.isPushContentWhenKeyboardShow = widget.isPushContentWhenKeyboardShow;
    widget.opacityListener?.setScrollController(scrollController);
  }

  @override
  void dispose() {
    widget.opacityListener?.removeScrollController();
    super.dispose();
  }

  @override
  void didUpdateWidget(BallisticCustomScrollView oldWidget) {
    if (oldWidget.appBar != widget.appBar) {
      oldWidget.appBar = widget.appBar;
    }
    if (oldWidget.upDisplay != widget.upDisplay) {
      oldWidget.upDisplay = widget.upDisplay;
    }
    if (oldWidget.display != widget.display) {
      oldWidget.display = widget.display;
    }
    if (oldWidget.positioneds != widget.positioneds ||
        oldWidget.positioneds!.length != widget.positioneds!.length) {
      oldWidget.positioneds = widget.positioneds;
    }
    if (oldWidget.isPushContentWhenKeyboardShow !=
        widget.isPushContentWhenKeyboardShow) {
      oldWidget.isPushContentWhenKeyboardShow =
          widget.isPushContentWhenKeyboardShow;
      super.isPushContentWhenKeyboardShow =
          widget.isPushContentWhenKeyboardShow;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
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
          ),
        ],
      ),
    );
  }
}

class BallisticSliverPersistentHeader {
  double? minExtent;
  double? maxExtent;
  bool? floating;
  bool? pinned;
  BuildPersistentHeader buildPersistentHeader;

  BallisticSliverPersistentHeader({
    this.minExtent,
    this.maxExtent,
    this.floating,
    this.pinned,
    required this.buildPersistentHeader,
  });
}

class BallisticSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  late double _minExtent;

  late double _maxExtent;
  BuildPersistentHeader buildPersistentHeader;

  BallisticSliverPersistentHeaderDelegate(
      {double? minExtent,
      double? maxExtent,
      required this.buildPersistentHeader}) {
    _maxExtent = maxExtent ?? 80;
    _minExtent = minExtent ?? 80;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //创建child子组件
    //shrinkOffset：child偏移值minExtent~maxExtent
    //overlapsContent：SliverPersistentHeader覆盖其他子组件返回true，否则返回false
    return buildPersistentHeader(
        context, shrinkOffset, overlapsContent, _minExtent, _maxExtent);
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => _maxExtent;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(
      covariant BallisticSliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
