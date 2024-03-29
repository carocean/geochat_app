///
///以下是基本类型定义
///
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:framework/core_lib/_ultimate.dart';

import '_ballistic_indicator_scroll_behavior_physics.dart';

typedef BuildHeaderChild = Widget Function(HeaderSettings? settings,
    HeaderNotifier headerNotifier, Axis scrollDirection);

enum IndicatorScrollMode {
  ///边界固定不动
  fixed,

  ///边界弹性滑动，但没有交互
  bouncing,

  ///边界产生用户交互。如需刷新或加载需使用此值
  interact,
}

class HeaderSettings
    implements IEqualable<HeaderSettings>, ICopyable<HeaderSettings> {
  IndicatorScrollMode? scrollMode;
  double reservePixels;
  double? expandPixels;
  BuildHeaderChild? buildChild;
  HeaderOnRefresh? onRefresh;

  HeaderSettings({
    this.scrollMode = IndicatorScrollMode.interact,

    ///头部预定的下滑高度
    this.reservePixels = 50.00,

    ///头部扩展的高度。该高度大于reservePixels才生效
    this.expandPixels,
    this.buildChild,
    this.onRefresh,
  });

  @override
  bool equalsTo(HeaderSettings? obj) {
    if (obj == null) {
      return false;
    }
    if (obj != this) {
      return false;
    }
    return reservePixels == obj.reservePixels &&
            expandPixels == obj.expandPixels &&
            buildChild == obj.buildChild &&
            onRefresh == obj.onRefresh &&
            scrollMode == obj.scrollMode
        ? true
        : false;
  }

  @override
  void copyFrom(HeaderSettings? obj) {
    if (obj == null) {
      return;
    }
    reservePixels = obj.reservePixels;
    expandPixels = obj.expandPixels;
    buildChild = obj.buildChild;
    onRefresh = obj.onRefresh;
    scrollMode = obj.scrollMode;
  }
}

typedef BuildFooterChild = Widget Function(FooterSettings? settings,
    FooterNotifier footerNotifier, Axis scrollDirection);

class FooterSettings
    implements IEqualable<FooterSettings>, ICopyable<FooterSettings> {
  double reservePixels;
  double? expandPixels;
  BuildFooterChild? buildChild;
  FooterOnLoad? onLoad;
  IndicatorScrollMode? scrollMode;

  FooterSettings({
    this.scrollMode = IndicatorScrollMode.interact,

    ///尾部预定的上滑高度
    this.reservePixels = 50.00,

    ///尾部可扩展高度。只有大于reservePixels时才生效
    this.expandPixels,
    this.buildChild,
    this.onLoad,
  });

  @override
  bool equalsTo(obj) {
    if (obj == null) {
      return false;
    }
    if (obj != this) {
      return false;
    }
    return reservePixels == obj.reservePixels &&
            expandPixels == obj.expandPixels &&
            buildChild == obj.buildChild &&
            onLoad == obj.onLoad &&
            scrollMode == obj.scrollMode
        ? true
        : false;
  }

  @override
  void copyFrom(FooterSettings? obj) {
    if (obj == null) {
      return;
    }
    reservePixels = obj.reservePixels;
    expandPixels = obj.expandPixels;
    buildChild = obj.buildChild;
    onLoad = obj.onLoad;
    scrollMode = obj.scrollMode;
  }
}

class FootView {
  Widget? child;
}

/// 指示器构建器
class IndicatorSettings implements IDisposable, IEqualable<IndicatorSettings> {
  /// Header status data and responsive
  late HeaderNotifier headerNotifier;

  /// Footer status data and responsive
  late FooterNotifier footerNotifier;
  final ValueNotifier<bool> userOffsetNotifier;
  late ScrollController scrollController;
  late Axis scrollDirection;
  late ScrollBehavior _scrollBehavior;
  HeaderSettings? headerSettings;
  FooterSettings? footerSettings;
  bool _isInnerCreateScrollController = true;

  ScrollBehavior get scrollBehavior => _scrollBehavior;

  IndicatorSettings() : userOffsetNotifier = ValueNotifier<bool>(false);

  @override
  bool equalsTo(IndicatorSettings? obj) {
    return scrollDirection != obj?.scrollDirection &&
        !(headerSettings != null &&
            headerSettings!.equalsTo(obj?.headerSettings)) &&
        !(footerSettings != null &&
            footerSettings!.equalsTo(obj?.footerSettings));
  }

  @override
  void dispose() {
    if (_isInnerCreateScrollController) {
      scrollController.dispose();
    }
    headerNotifier.dispose();
    footerNotifier.dispose();
  }

  IndicatorSettings bindHeaderSettings(HeaderSettings? headerSettings) {
    this.headerSettings = headerSettings;
    return this;
  }

  IndicatorSettings bindFooterSettings(FooterSettings? footerSettings) {
    this.footerSettings = footerSettings;
    return this;
  }

  IndicatorSettings bindScrollDirection(Axis? scrollDirection) {
    this.scrollDirection = scrollDirection ?? Axis.vertical;
    return this;
  }

  IndicatorSettings build(
      {ScrollController? scrollController,
      ExpandPanelStateEvent headerExpandPanelStateEvent,
      ExpandPanelStateEvent footerExpandPanelStateEvent}) {
    _isInnerCreateScrollController = (scrollController == null ? true : false);
    this.scrollController = scrollController ?? ScrollController();

    headerNotifier = HeaderNotifier(
      reservePixels: headerSettings?.reservePixels ?? 50.00,
      expandPixels: headerSettings?.expandPixels,
      scrollMode: headerSettings?.scrollMode ?? IndicatorScrollMode.interact,
      scrollController: this.scrollController,
      userOffsetNotifier: userOffsetNotifier,
      onRefresh: headerSettings?.onRefresh,
      scrollState: ScrollState.underScrollInit,
      expandPanelStateEvent: headerExpandPanelStateEvent,
    );

    footerNotifier = FooterNotifier(
      reservePixels: footerSettings?.reservePixels ?? 50.00,
      expandPixels: footerSettings?.expandPixels,
      scrollMode: footerSettings?.scrollMode ?? IndicatorScrollMode.interact,
      scrollController: this.scrollController,
      userOffsetNotifier: userOffsetNotifier,
      onLoad: footerSettings?.onLoad,
      scrollState: ScrollState.overScrollInit,
      expandPanelStateEvent: footerExpandPanelStateEvent,
    );

    var scrollPhysics = IndicatorScrollPhysics(
      headerNotifier: headerNotifier,
      footerNotifier: footerNotifier,
      userOffsetNotifier: userOffsetNotifier,
    );
    _scrollBehavior = IndicatorScrollBehavior(scrollPhysics);
    return this;
  }

  void updateHeaderSettings(HeaderSettings? headerSettings) {
    if (headerSettings == null) {
      return;
    }
    this.headerSettings?.copyFrom(headerSettings);
    headerNotifier.updateFromSettings(headerSettings);
  }

  void updateFooterSettings(FooterSettings? footerSettings) {
    if (footerSettings == null) {
      return;
    }
    this.footerSettings?.copyFrom(footerSettings);
    footerNotifier.updateFromSettings(footerSettings);
  }

  void updateScrollDirection(Axis? scrollDirection) {
    this.scrollDirection = scrollDirection ?? Axis.vertical;
  }
}

class IndicatorInheritedWidget extends InheritedWidget {
  final IndicatorSettings indicatorSettings;

  const IndicatorInheritedWidget({
    Key? key,
    required this.indicatorSettings,
    required Widget child,
  }) : super(key: key, child: child);

//定义一个便捷方法，方便子树中的widget获取共享数据
  static IndicatorInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IndicatorInheritedWidget>();
    // return context
    //     .getElementForInheritedWidgetOfExactType<IndicatorInheritedWidget>()!
    //     .widget as IndicatorInheritedWidget?;
  }

  @override
  bool updateShouldNotify(covariant IndicatorInheritedWidget oldWidget) =>
      indicatorSettings != oldWidget.indicatorSettings;
}

///指示器通知器。借助ChangeNotifier机制通知局部组件的状态更新
class IndicatorNotifier extends ChangeNotifier {
  ValueListenable<IndicatorNotifier> listenable() => _IndicatorListenable(this);
}

class _IndicatorListenable<T extends IndicatorNotifier>
    extends ValueListenable<T> {
  /// Indicator notifier
  final T _indicatorNotifier;

  _IndicatorListenable(this._indicatorNotifier);

  final List<VoidCallback> _listeners = [];

  /// Listen for notifications
  void _onNotify() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      _indicatorNotifier.addListener(_onNotify);
    }
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _indicatorNotifier.removeListener(_onNotify);
    }
  }

  @override
  T get value => _indicatorNotifier;
}

enum ScrollState {
  sliding,
  underScrollInit,
  underScrolling,
  underScrollEnd,
  underScrollRefreshing,
  underScrollRefreshDone,
  underScrollCollapsing,
  underScrollCollapseDone,
  hitTopEdge,
  overScrollInit,
  overScrolling,
  overScrollEnd,
  overScrollLoading,
  overScrollLoadDone,
  overScrollCollapsing,
  overScrollCollapseDone,
  hitBottomEdge,
}

enum ExpandPanelState {
  init,
  invalid,
  opening,
  opened,
  closing,
  closed,
}

typedef HeaderOnRefresh = Future<void> Function();
typedef ExpandPanelStateEvent = Function(ExpandPanelState? state)?;

class HeaderNotifier extends IndicatorNotifier {
  double reservePixels;
  double? expandPixels;
  ScrollMetrics? position;
  IndicatorScrollMode? scrollMode;
  ScrollState? scrollState;
  double value;
  HeaderOnRefresh? onRefresh;
  final ScrollController? scrollController;
  final ValueNotifier<bool> userOffsetNotifier;
  ExpandPanelState? expandPanelState;
  ExpandPanelStateEvent expandPanelStateEvent;

  HeaderNotifier({
    this.reservePixels = 0.0,
    this.expandPixels,
    this.value = 0.0,
    this.scrollState,
    this.scrollMode = IndicatorScrollMode.interact,
    this.position,
    this.onRefresh,
    this.scrollController,
    required this.userOffsetNotifier,
    this.expandPanelState = ExpandPanelState.init,
    this.expandPanelStateEvent,
  });

  void updatePosition(
      ScrollMetrics position, ScrollState scrollState, double value) {
    //如果在用户触屏时还在加载则什么也不做
    if (userOffsetNotifier.value &&
        this.scrollState == ScrollState.underScrollRefreshing) {
      return;
    }
    this.position = position;
    this.value = value;
    if (userOffsetNotifier.value) {
      this.scrollState = scrollState;
    } else {
      //非用户触摸，即滚动控制方式
      if (scrollState == ScrollState.sliding &&
          this.scrollState != ScrollState.underScrollCollapsing &&
          this.scrollState != ScrollState.underScrollCollapseDone) {
        this.scrollState = scrollState;
      }
    }

    //处理抽屉模式
    if (position.pixels <= position.minScrollExtent &&
        (expandPixels ?? 0) > reservePixels) {
      _translateToExpandState(position, scrollState, value);
      if (expandPanelStateEvent != null) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          expandPanelStateEvent!(expandPanelState);
        });
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });

    if (scrollState == ScrollState.underScrollEnd) {
      this.scrollState = ScrollState.underScrollRefreshing;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        notifyListeners();
      });
      _processRefresh().then((value) async {
        this.scrollState = ScrollState.underScrollRefreshDone;
        notifyListeners();
        if (reservePixels >= (expandPixels ?? 0)) {
          //为了看清状态delayed后再收起
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          this.scrollState = ScrollState.underScrollCollapsing;
          notifyListeners();
          await scrollController?.animateTo(
            position.minScrollExtent,
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 400),
          );
          this.scrollState = ScrollState.underScrollCollapseDone;
          notifyListeners();
        }
      });
    }
  }

  void _translateToExpandState(
      ScrollMetrics position, ScrollState state, double value) {
    switch (state) {
      case ScrollState.underScrollInit:
        expandPanelState = ExpandPanelState.init;
        break;
      case ScrollState.underScrolling:
        expandPanelState = ExpandPanelState.opening;
        break;
      case ScrollState.underScrollEnd:
        expandPanelState = ExpandPanelState.opened;
        break;
      case ScrollState.underScrollCollapsing:
        expandPanelState = ExpandPanelState.closing;
        break;
      case ScrollState.underScrollCollapseDone:
        expandPanelState = ExpandPanelState.closed;
        break;
      case ScrollState.sliding:
        expandPanelState ??= ExpandPanelState.init;
        if (expandPanelState == ExpandPanelState.closed ||
            expandPanelState == ExpandPanelState.init ||
            expandPanelState == ExpandPanelState.invalid) {
          expandPanelState = ExpandPanelState.opening;
          break;
        }
        if (expandPanelState == ExpandPanelState.opened) {
          expandPanelState = ExpandPanelState.closing;
          break;
        }
        if (expandPanelState == ExpandPanelState.opening &&
            value == position.minScrollExtent) {
          expandPanelState = ExpandPanelState.invalid;
          break;
        }
        break;
    }
  }

  Future<void> _processRefresh() async {
    if (onRefresh == null) {
      return;
    }
    await onRefresh!();
  }

  void updateFromSettings(HeaderSettings headerSettings) {
    scrollMode = headerSettings.scrollMode;
    onRefresh = headerSettings.onRefresh;
    reservePixels = headerSettings.reservePixels;
    expandPixels = headerSettings.expandPixels;
  }
}

typedef FooterOnLoad = Future<void> Function();

class FooterNotifier extends IndicatorNotifier {
  double reservePixels;
  double? expandPixels;
  ScrollMetrics? position;
  IndicatorScrollMode? scrollMode;
  ScrollState? scrollState;
  double value;
  FooterOnLoad? onLoad;
  final ScrollController? scrollController;
  final ValueNotifier<bool> userOffsetNotifier;
  ExpandPanelState? expandPanelState;
  ExpandPanelStateEvent expandPanelStateEvent;

  FooterNotifier({
    this.reservePixels = 0.0,
    this.expandPixels,
    this.value = 0.0,
    this.scrollState,
    this.scrollMode = IndicatorScrollMode.interact,
    this.position,
    this.onLoad,
    this.scrollController,
    required this.userOffsetNotifier,
    this.expandPanelState = ExpandPanelState.init,
    this.expandPanelStateEvent,
  });

  void updatePosition(
      ScrollMetrics position, ScrollState scrollState, double value) {
    //如果在用户触屏时还在加载则什么也不做
    if (userOffsetNotifier.value &&
        this.scrollState == ScrollState.overScrollLoading) {
      return;
    }
    this.position = position;
    this.value = value;
    if (userOffsetNotifier.value) {
      this.scrollState = scrollState;
    } else {
      //非用户触摸，即滚动控制方式
      if (scrollState == ScrollState.sliding &&
          this.scrollState != ScrollState.overScrollCollapsing &&
          this.scrollState != ScrollState.overScrollCollapseDone) {
        this.scrollState = scrollState;
      }
    }
    //抽屉模式
    if (position.pixels >= position.maxScrollExtent &&
        (expandPixels ?? 0) > reservePixels) {
      _translateToExpandState(position, scrollState, value);
      if (expandPanelStateEvent != null) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          expandPanelStateEvent!(expandPanelState);
        });
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });

    if (scrollState == ScrollState.overScrollEnd) {
      this.scrollState = ScrollState.overScrollLoading;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        notifyListeners();
      });
      _processLoad().then((value) async {
        this.scrollState = ScrollState.overScrollLoadDone;
        notifyListeners();
        if (reservePixels >= (expandPixels ?? 0)) {
          //为了看清状态delayed后再收起
          await Future.delayed(
            const Duration(
              milliseconds: 200,
            ),
          );
          this.scrollState = ScrollState.overScrollCollapsing;
          notifyListeners();
          await scrollController?.animateTo(
            scrollController?.position.maxScrollExtent ?? 0.0,
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 500),
          );
          this.scrollState = ScrollState.overScrollCollapseDone;
          notifyListeners();
        }
      });
    }
  }

  void _translateToExpandState(
      ScrollMetrics position, ScrollState state, double value) {
    switch (state) {
      case ScrollState.overScrollInit:
        expandPanelState = ExpandPanelState.init;
        break;
      case ScrollState.overScrolling:
        expandPanelState = ExpandPanelState.opening;
        break;
      case ScrollState.overScrollEnd:
        expandPanelState = ExpandPanelState.opened;
        break;
      case ScrollState.overScrollCollapsing:
        expandPanelState = ExpandPanelState.closing;
        break;
      case ScrollState.overScrollCollapseDone:
        expandPanelState = ExpandPanelState.closed;
        break;
      case ScrollState.sliding:
        expandPanelState ??= ExpandPanelState.init;
        if (expandPanelState == ExpandPanelState.closed ||
            expandPanelState == ExpandPanelState.init ||
            expandPanelState == ExpandPanelState.invalid) {
          expandPanelState = ExpandPanelState.opening;
          break;
        }
        if (expandPanelState == ExpandPanelState.opened) {
          expandPanelState = ExpandPanelState.closing;
          break;
        }
        if (expandPanelState == ExpandPanelState.opening &&
            value == position.maxScrollExtent) {
          expandPanelState = ExpandPanelState.invalid;
          break;
        }
        break;
    }
  }

  Future<void> _processLoad() async {
    if (onLoad == null) {
      return;
    }
    await onLoad!();
  }

  void updateFromSettings(FooterSettings footerSettings) {
    reservePixels = footerSettings.reservePixels;
    scrollMode = footerSettings.scrollMode;
    onLoad = footerSettings.onLoad;
    expandPixels = footerSettings.expandPixels;
  }
}
