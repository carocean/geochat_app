import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_ballistic_custom_scroll_view.dart';
import '_ballistic_layout.dart';
import '_opacity_listener.dart';

///与 BallisticCustomScrollView 的区别是：
///BallisticNestedScrollView的上下拉从吸附栏的下方开始，而BallisticCustomScrollView是从最顶部开始，是整体的。
class BallisticNestedScrollView extends StatefulWidget {
  BallisticNestedScrollView({
    Key? key,
    this.appBar,
    this.upDisplay,
    this.persistentHeader,
    required this.display,
    this.displayNeverPhysics,
    this.fixedFooter,
    this.positioneds,
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
  }) : super(key: key) {
    positioneds ??= [];
  }

  SliverAppBar? appBar;
  Widget? upDisplay;
  final BallisticSliverPersistentHeader? persistentHeader;
  Widget display;
  bool? displayNeverPhysics;
  Widget? fixedFooter;
  List<Positioned>? positioneds;
  final OpacityListener? opacityListener;

  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;

  @override
  State<BallisticNestedScrollView> createState() =>
      _BallisticNestedScrollViewState();
}

class _BallisticNestedScrollViewState
    extends BallisticSliverLayout<BallisticNestedScrollView> {
  ScrollController? _nestedScrollController;

  @override
  void initState() {
    super.initState();
    _nestedScrollController = ScrollController();
    if (!kIsWeb) {
      scrollController.addListener(() {
        _nestedScrollController?.jumpTo(scrollController.offset);
      });
    }
    super.isPushContentWhenKeyboardShow = widget.isPushContentWhenKeyboardShow;
    widget.opacityListener?.setScrollController(_nestedScrollController!);
  }

  @override
  void dispose() {
    _nestedScrollController?.dispose();
    widget.opacityListener?.removeScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: NestedScrollView(
        controller: _nestedScrollController,
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
        body: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(0),
                      controller: scrollController,
                      physics: (widget.displayNeverPhysics ?? false)
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                          minWidth: constraints.maxWidth,
                        ),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            widget.display,
                            ...widget.positioneds ?? [],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              widget.fixedFooter ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
