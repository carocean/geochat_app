import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///惯性布局,需自己实现布局规则。如简单使用用InertialLayout2
abstract class InertialLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  double _bottom = 0.0;
  late ScrollController _scrollController;

  double get bottom => _bottom;

  ScrollController get scrollController => _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // 键盘高度
    final double viewInsetsBottom = EdgeInsets.fromWindowPadding(
            WidgetsBinding.instance.window.viewInsets,
            WidgetsBinding.instance.window.devicePixelRatio)
        .bottom;

    if (kDebugMode) {
      print(viewInsetsBottom);
    }

    if (mounted) {
      setState(() {
        _bottom = viewInsetsBottom;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          //build完成后的回调
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent, //滚动到底部
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  double scrollViewHeight(AppBar? appBar, {BuildContext? parentContext}) {
    var context = parentContext ?? this.context;
    double appBarHeight = appBar?.preferredSize.height ?? 0.0;
    var scrollViewHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBarHeight -
        _bottom;
    return scrollViewHeight;
  }
}

///惯性布局2，使用更简单
abstract class InertialLayout2<T extends StatefulWidget>
    extends InertialLayout<T> with WidgetsBindingObserver {
  Widget buildInertialLayout(
    BuildContext context, {
    DecorationImage? backgroundImage,
    AppBar? appBar,
    required Widget display,
    required List<Positioned> positionedList,
  }) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: backgroundImage,
        ),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: scrollViewHeight(appBar),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  display,
                  ...positionedList,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///惯性布局，控件化
class InertialLayout3 extends StatefulWidget {
  AppBar? appBar;
  final BuildContext parentContext;
  late Widget display;
  late List<Positioned> positionedList;

  InertialLayout3(
      {Key? key,
      required this.parentContext,
      this.appBar,
      required this.display,
      required this.positionedList})
      : super(key: key);

  @override
  State<InertialLayout3> createState() => _InertialLayout3State();
}

class _InertialLayout3State extends InertialLayout<InertialLayout3> {
  @override
  void didUpdateWidget(InertialLayout3 oldWidget) {
    if (oldWidget.appBar != widget.appBar) {
      oldWidget.appBar = widget.appBar;
    }
    if (oldWidget.display != widget.display) {
      oldWidget.display = widget.display;
    }
    if (oldWidget.positionedList != widget.positionedList ||
        oldWidget.positionedList.length != widget.positionedList.length) {
      oldWidget.positionedList = widget.positionedList;
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
            minHeight: scrollViewHeight(widget.appBar,parentContext: widget.parentContext),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              widget.display,
              ...widget.positionedList,
            ],
          ),
        ),
      ),
    );
  }
}
