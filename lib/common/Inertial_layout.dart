import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    _scrollController.dispose();
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

typedef OpacityEvent = void Function(double);

class OpacityListener {
  late ScrollController _scrollController;
  OpacityEvent opacityEvent;
  double scrollHeight = 56;
  int piecs = 100;
  int startEdgeSize = 0;
  int endEdgeSize = 0;
  double _opacity = 1; //范围 0-1
  late double _initValue;

  OpacityListener({
    required this.opacityEvent,

    ///开始是完全透明还是不透明
    bool beginOpacity = true,

    ///活动的高度区间
    required this.scrollHeight,

    ///假如分一百份
    this.piecs = 100,

    ///到达边界的区间和度，如到上边界的区间范围，直接透明度给1；到下边界的区间范围，则直接给0，即透明。
    this.startEdgeSize = 0,
    this.endEdgeSize=0,
  }) {
    if(startEdgeSize+endEdgeSize>=scrollHeight) {
      throw FlutterError('开始和结束区间之和大于等于滚动区间!');
    }
    _opacity = beginOpacity ? 0 : 1;
    _initValue = _opacity;
  }

  static double getAppBarHeight(AppBar appBar) {
    return appBar.preferredSize.height;
  }

  void setScrollController(ScrollController scrollController) {
    _scrollController=scrollController;
    _scrollController.addListener(listen);
  }

  void removeScrollController() {
    _scrollController.removeListener(listen);
  }

  void listen() {
    var validScrollHeight=scrollHeight-startEdgeSize-endEdgeSize;
    var scrollPiceHeight = validScrollHeight / piecs; //每份的偏移高度
    var scrollPiceOpacity = 1 / piecs; //每份的偏移透明度
    if (_scrollController.offset >=
        (scrollHeight - endEdgeSize)) {
      if (_opacity == 1 - _initValue) {
        return;
      }
      _opacity = 1 - _initValue;
    } else if (_scrollController.offset <= startEdgeSize) {
      if (_opacity == _initValue) {
        return;
      }
      _opacity = _initValue;
    } else {
      var incr =
          ((_scrollController.offset-startEdgeSize) / scrollPiceHeight) * scrollPiceOpacity;
      if (_initValue == 1) {
        _opacity = 1 - incr;
      } else if (_initValue == 0) {
        _opacity = incr;
      } else {
        throw FlutterError('初始透明度必须是0或1的值');
      }
    }
    opacityEvent(_opacity);
  }
}

///惯性布局，控件化
class InertialLayoutWidget extends StatefulWidget {
  AppBar? appBar;
  final BuildContext parentContext;
  late Widget display;
  late List<Positioned>? positioneds;
  late OpacityListener? opacityListener;

  InertialLayoutWidget({
    Key? key,
    required this.parentContext,
    this.appBar,
    required this.display,
    this.positioneds,
    this.opacityListener,
  }) : super(key: key) {
    positioneds ??= [];
  }

  @override
  State<InertialLayoutWidget> createState() => _InertialLayoutWidgetState();
}

class _InertialLayoutWidgetState extends InertialLayout<InertialLayoutWidget> {
  @override
  void initState() {
    super.initState();
    widget.opacityListener?.setScrollController(scrollController);
  }

  @override
  void dispose() {
    widget.opacityListener?.removeScrollController();
    super.dispose();
  }

  @override
  void didUpdateWidget(InertialLayoutWidget oldWidget) {
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
