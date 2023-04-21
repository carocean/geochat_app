import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:framework/core_lib/_ultimate.dart';

import '_ballistic_indicator_scroll_behavior_physics.dart';

///
///以下是基本类型定义
///

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

  IndicatorSettings build(CreateScrollBehavior createScrollBehavior) {
    _scrollBehavior = createScrollBehavior(this);
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
  hitTopEdge,
  overScrolling,
  overScrollEnd,
  hitBottomEdge,
}

class HeaderNotifier extends IndicatorNotifier {
  double reservePixels;
  ScrollMetrics? position;
  bool isForbidScroll;
  ScrollState? scrollState;
  double value;

  HeaderNotifier({
    this.reservePixels = 0.0,
    this.value = 0.0,
    this.scrollState,
    this.isForbidScroll = false,
    this.position,
  });

  void updatePosition(ScrollMetrics position, ScrollState scrollState) {
    this.position = position;
    this.scrollState = scrollState;
    notifyListeners();
  }
}

class FooterNotifier extends IndicatorNotifier {
  double reservePixels;
  ScrollMetrics? position;
  bool isForbidScroll;
  ScrollState? scrollState;
  double value;

  FooterNotifier({
    this. reservePixels = 0.0,
    this. value = 0.0,
    this. scrollState,
    this. isForbidScroll = false,
    this. position,
  })  ;

  void updatePosition(ScrollMetrics position, ScrollState scrollState) {
    this.position = position;
    this.scrollState = scrollState;
    notifyListeners();
  }
}
