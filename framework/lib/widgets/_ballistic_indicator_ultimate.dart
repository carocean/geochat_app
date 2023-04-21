///
///以下是基本类型定义
///
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:framework/core_lib/_ultimate.dart';

import '_ballistic_indicator_scroll_behavior_physics.dart';

class HeaderSettings {
  double reservePixcels;
  double? expandPixcels;
  Widget? child;
  HeaderOnRefresh? onRefresh;

  HeaderSettings({
    this.reservePixcels = 50.00,
    this.expandPixcels,
    this.child,
    this.onRefresh,
  });
}

class FooterSettings {
  double reservePixcels;
  double? expandPixcels;
  Widget? child;
  FooterOnLoad? onLoad;

  FooterSettings({
    this.reservePixcels = 50.00,
    this.expandPixcels,
    this.child,
    this.onLoad,
  });
}

class FootView {
  Widget? child;
}

/// 指示器构建器
class IndicatorSettings implements IDisposable {
  /// Header status data and responsive
  final HeaderNotifier headerNotifier;

  /// Footer status data and responsive
  final FooterNotifier footerNotifier;
  final ValueNotifier<bool> userOffsetNotifier;
  final ScrollController scrollController;
  Axis scrollDirection;
  late ScrollBehavior _scrollBehavior;
  HeaderSettings? headerSettings;
  FooterSettings? footerSettings;

  ScrollBehavior get scrollBehavior => _scrollBehavior;

  IndicatorSettings({
    required this.scrollController,
    required this.headerNotifier,
    required this.footerNotifier,
    required this.userOffsetNotifier,
    required this.scrollDirection,
  });

  @override
  void dispose() {
    scrollController?.dispose();
    headerNotifier.dispose();
    footerNotifier.dispose();
  }

  IndicatorSettings bindScrollBehavior(
      CreateScrollBehavior createScrollBehavior) {
    _scrollBehavior = createScrollBehavior(this);
    return this;
  }

  IndicatorSettings bindHeaderSettings(HeaderSettings? headerSettings) {
    this.headerSettings = headerSettings;
    headerNotifier.onRefresh = headerSettings?.onRefresh;
    headerNotifier.reservePixels = headerSettings?.reservePixcels ?? 40.00;
    return this;
  }

  IndicatorSettings bindFooterSettings(FooterSettings? footerSettings) {
    this.footerSettings = footerSettings;
    footerNotifier.onLoad = footerSettings?.onLoad;
    footerNotifier.reservePixels = footerSettings?.reservePixcels ?? 50.00;
    return this;
  }
}

class IndicatorInheritedWidget extends InheritedWidget {
  final IndicatorSettings indicatorSettings;

  const IndicatorInheritedWidget({
    Key? key,
    required this.indicatorSettings,
    required Widget child,
  }) : super(key: key, child: child);

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
  underScrolling,
  underScrollEnd,
  underScrollRefreshing,
  underScrollRefreshDone,
  underScrollCollapsing,
  underScrollCollapseDone,
  hitTopEdge,
  overScrolling,
  overScrollEnd,
  overScrollLoading,
  overScrollLoadDone,
  overScrollCollapsing,
  overScrollCollapseDone,
  hitBottomEdge,
}

typedef HeaderOnRefresh = Future<void> Function();

class HeaderNotifier extends IndicatorNotifier {
  double reservePixels;
  ScrollMetrics? position;
  bool isForbidScroll;
  ScrollState? scrollState;
  double value;
  HeaderOnRefresh? onRefresh;
  ScrollController? scrollController;
  final ValueNotifier<bool> userOffsetNotifier;

  HeaderNotifier({
    this.reservePixels = 0.0,
    this.value = 0.0,
    this.scrollState,
    this.isForbidScroll = false,
    this.position,
    this.onRefresh,
    this.scrollController,
    required this.userOffsetNotifier,
  });

  void updatePosition(
      ScrollMetrics position, ScrollState scrollState, double value) {
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
    notifyListeners();
    if (scrollState == ScrollState.underScrollEnd) {
      this.scrollState = ScrollState.underScrollRefreshing;
      notifyListeners();
      _processRefresh().then((value) async {
        this.scrollState = ScrollState.underScrollRefreshDone;
        notifyListeners();
        //为了看清状态delayed后再收起
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        this.scrollState = ScrollState.underScrollCollapsing;
        notifyListeners();
        await scrollController?.animateTo(
          position?.minScrollExtent ?? 0.0,
          curve: Curves.bounceInOut,
          duration: const Duration(milliseconds: 400),
        );
        this.scrollState = ScrollState.underScrollCollapseDone;
        notifyListeners();
      });
    }
  }

  Future<void> _processRefresh() async {
    if (onRefresh == null) {
      return;
    }
    await onRefresh!();
  }
}

typedef FooterOnLoad = Future<void> Function();

class FooterNotifier extends IndicatorNotifier {
  double reservePixels;
  ScrollMetrics? position;
  bool isForbidScroll;
  ScrollState? scrollState;
  double value;
  FooterOnLoad? onLoad;
  ScrollController? scrollController;
  final ValueNotifier<bool> userOffsetNotifier;

  FooterNotifier({
    this.reservePixels = 0.0,
    this.value = 0.0,
    this.scrollState,
    this.isForbidScroll = false,
    this.position,
    this.onLoad,
    this.scrollController,
    required this.userOffsetNotifier,
  });

  void updatePosition(
      ScrollMetrics position, ScrollState scrollState, double value) {
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
    notifyListeners();
    if (scrollState == ScrollState.overScrollEnd) {
      this.scrollState = ScrollState.overScrollLoading;
      notifyListeners();
      _processLoad().then((value) async {
        this.scrollState = ScrollState.overScrollLoadDone;
        notifyListeners();
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
      });
    }
  }

  Future<void> _processLoad() async {
    if (onLoad == null) {
      return;
    }
    await onLoad!();
  }
}
