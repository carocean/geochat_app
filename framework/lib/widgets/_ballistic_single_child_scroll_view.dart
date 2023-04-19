
import 'package:flutter/material.dart';

import '_ballistic_layout.dart';
import '_opacity_listener.dart';

///惯性布局，控件化。增加透明度事件
class BallisticSingleChildScrollView extends StatefulWidget {
  AppBar? appBar;
  final BuildContext parentContext;
  Widget display;
  List<Positioned>? positioneds;
  OpacityListener? opacityListener;

  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;

  BallisticSingleChildScrollView({
    Key? key,
    required this.parentContext,
    this.appBar,
    required this.display,
    this.positioneds = const <Positioned>[],
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
  }) : super(key: key) ;

  @override
  State<BallisticSingleChildScrollView> createState() =>
      _BallisticSingleChildScrollViewState();
}

class _BallisticSingleChildScrollViewState
    extends BallisticLayout<BallisticSingleChildScrollView> {
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
  void didUpdateWidget(BallisticSingleChildScrollView oldWidget) {
    if (oldWidget.appBar != widget.appBar) {
      oldWidget.appBar = widget.appBar;
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
    return SizedBox.expand(
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: scrollViewHeight(widget.appBar,
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
    );
  }
}
