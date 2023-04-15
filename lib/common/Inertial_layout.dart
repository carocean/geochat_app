import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///惯性布局,需自己实现布局规则。如简单使用用InertialLayoutWidget
abstract class InertialLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  double _bottom = 0.0;
  late ScrollController _scrollController;
  bool? isPushContentWhenKeyboardShow;

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
    bool beginIsOpacity = true,

    ///活动的高度区间
    required this.scrollHeight,

    ///假如分一百份
    this.piecs = 100,

    ///到达边界的区间和度，如到上边界的区间范围，直接透明度给1；到下边界的区间范围，则直接给0，即透明。
    this.startEdgeSize = 0,
    this.endEdgeSize = 0,
  }) {
    if (startEdgeSize + endEdgeSize >= scrollHeight) {
      throw FlutterError('开始和结束区间之和大于等于滚动区间!');
    }
    _opacity = beginIsOpacity ? 0 : 1;
    _initValue = _opacity;
  }

  static double getAppBarHeight(AppBar appBar) {
    return appBar.preferredSize.height;
  }

  void setScrollController(ScrollController scrollController) {
    _scrollController = scrollController;
    _scrollController.addListener(listen);
  }

  void removeScrollController() {
    _scrollController.removeListener(listen);
  }

  void listen() {
    var validScrollHeight = scrollHeight - startEdgeSize - endEdgeSize;
    var scrollPiceHeight = validScrollHeight / piecs; //每份的偏移高度
    var scrollPiceOpacity = 1 / piecs; //每份的偏移透明度
    if (_scrollController.offset >= (scrollHeight - endEdgeSize)) {
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
          ((_scrollController.offset - startEdgeSize) / scrollPiceHeight) *
              scrollPiceOpacity;
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

///惯性布局，控件化。增加透明度事件
class InertialLayoutWidget extends StatefulWidget {
  AppBar? appBar;
  final BuildContext parentContext;
  Widget display;
  List<Positioned>? positioneds;
  OpacityListener? opacityListener;

  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;

  InertialLayoutWidget({
    Key? key,
    required this.parentContext,
    this.appBar,
    required this.display,
    this.positioneds,
    this.opacityListener,
    this.isPushContentWhenKeyboardShow = false,
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
    super.isPushContentWhenKeyboardShow = widget.isPushContentWhenKeyboardShow;
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

typedef BuildPersistentHeader = Widget Function(
  BuildContext context,
  double shrinkOffset,
  bool overlapsContent,
  double minExtent,
  double maxExtent,
);

///惯性布局,需自己实现布局规则。如简单使用用InertialLayoutWidget
abstract class InertialSliverLayout<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  bool? isPushContentWhenKeyboardShow;

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
    if (!(isPushContentWhenKeyboardShow ?? false)) {
      return;
    }

    if (mounted) {
      setState(() {
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
}

class InertialSliverLayoutWidget extends StatefulWidget {
  SliverAppBar? appBar;
  final BuildContext parentContext;
  Widget? upDisplay;
  InertialSliverPersistentHeader? persistentHeader;
  Widget display;
  List<Positioned>? positioneds;
  OpacityListener? opacityListener;

  ///当键盘在输入框聚焦弹出时，是否上推内容
  late bool? isPushContentWhenKeyboardShow;

  InertialSliverLayoutWidget({
    Key? key,
    required this.parentContext,
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
  State<InertialSliverLayoutWidget> createState() =>
      _InertialSliverLayoutWidgetState();
}

class _InertialSliverLayoutWidgetState
    extends InertialSliverLayout<InertialSliverLayoutWidget> {
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
  void didUpdateWidget(InertialSliverLayoutWidget oldWidget) {
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
    if(oldWidget.isPushContentWhenKeyboardShow!=widget.isPushContentWhenKeyboardShow) {
      oldWidget.isPushContentWhenKeyboardShow=widget.isPushContentWhenKeyboardShow;
      super.isPushContentWhenKeyboardShow = widget.isPushContentWhenKeyboardShow;
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
            child: widget.upDisplay ?? SizedBox.shrink(),
          ),
          widget.persistentHeader == null
              ? const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                )
              : SliverPersistentHeader(
                  delegate: InertialSliverPersistentHeaderDelegate(
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

class InertialSliverPersistentHeader {
  double? minExtent;
  double? maxExtent;
  bool? floating;
  bool? pinned;
  BuildPersistentHeader buildPersistentHeader;

  InertialSliverPersistentHeader({
    this.minExtent,
    this.maxExtent,
    this.floating,
    this.pinned,
    required this.buildPersistentHeader,
  });
}

class InertialSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  late double _minExtent;

  late double _maxExtent;
  BuildPersistentHeader buildPersistentHeader;

  InertialSliverPersistentHeaderDelegate(
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
      covariant InertialSliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
