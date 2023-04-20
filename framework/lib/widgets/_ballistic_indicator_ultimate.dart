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
class IndicatorNotifier extends ChangeNotifier {}

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
  double _reservePixels;
  ScrollMetrics? _position;
  bool _isForbidScroll;
  ScrollState? _scrollState;
  double _value;

  HeaderNotifier({
    double reservePixels = 0.0,
    double value = 0.0,
    ScrollState? scrollState,
    bool isForbidScroll = false,
    ScrollMetrics? position,
  })  : _reservePixels = reservePixels,
        _isForbidScroll = isForbidScroll,
        _scrollState = scrollState,
        _value = value,
        _position = position;


  ScrollState? get scrollState => _scrollState;

  set scrollState(ScrollState? value) {
    _scrollState = value;
    listenable();
  }

  double get value => _value;

  set value(double value) {
    _value = value;
    listenable();
  }

  double get reservePixels => _reservePixels;

  set reservePixels(double value) {
    _reservePixels = value;
    listenable();
  }

  ScrollMetrics? get position => _position;

  set position(ScrollMetrics? value) {
    _position = value;
    listenable();
  }

  bool get isForbidScroll => _isForbidScroll;

  set isForbidScroll(bool value) {
    _isForbidScroll = value;
    listenable();
  }

  ValueListenable<HeaderNotifier> listenable() => _IndicatorListenable(this);

  void updatePosition(ScrollMetrics position, ScrollState scrollState) {
    _position=position;
    _scrollState=scrollState;
    listenable();
  }

}

class FooterNotifier extends IndicatorNotifier {
  double _reservePixels;
  ScrollMetrics? _position;
  bool _isForbidScroll;
  ScrollState? _scrollState;
  double _value;

  FooterNotifier({
    double reservePixels = 0.0,
    double value = 0.0,
    ScrollState? scrollState,
    bool isForbidScroll = false,
    ScrollMetrics? position,
  })  : _reservePixels = reservePixels,
        _isForbidScroll = isForbidScroll,
        _scrollState = scrollState,
        _value = value,
        _position = position;


  ScrollState? get scrollState => _scrollState;

  set scrollState(ScrollState? value) {
    _scrollState = value;
    listenable();
  }

  double get value => _value;

  set value(double value) {
    _value = value;
    listenable();
  }

  double get reservePixels => _reservePixels;

  set reservePixels(double value) {
    _reservePixels = value;
    listenable();
  }

  ScrollMetrics? get position => _position;

  set position(ScrollMetrics? value) {
    _position = value;
    listenable();
  }

  bool get isForbidScroll => _isForbidScroll;

  set isForbidScroll(bool value) {
    _isForbidScroll = value;
    listenable();
  }
  void updatePosition(ScrollMetrics position, ScrollState scrollState) {
    _position=position;
    _scrollState=scrollState;
    listenable();
  }

  ValueListenable<FooterNotifier> listenable() => _IndicatorListenable(this);
}
