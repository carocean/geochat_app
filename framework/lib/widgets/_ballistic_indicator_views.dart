import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';

class _IndicatorHeaderView extends InheritedWidget {
  _IndicatorHeaderView(
      {required super.child,
      this.textStyle,
      this.headerSettings,
      this.headerNotifier});

  TextStyle? textStyle;
  HeaderSettings? headerSettings;
  HeaderNotifier? headerNotifier;

  @override
  bool updateShouldNotify(covariant _IndicatorHeaderView oldWidget) {
    return textStyle != oldWidget.textStyle &&
        !(headerSettings != null &&
            headerSettings!.equalsTo(oldWidget.headerSettings));
  }
}

class SimpleHeaderView extends StatelessWidget {
  const SimpleHeaderView(
      {Key? key,
      this.textStyle,
      this.headerNotifier,
      this.headerSettings,
      this.scrollDirection})
      : super(key: key);

  final Axis? scrollDirection;
  final TextStyle? textStyle;

  final HeaderSettings? headerSettings;
  final HeaderNotifier? headerNotifier;

  @override
  Widget build(BuildContext context) {
    var tips = '';
    switch (headerNotifier?.scrollState) {
      case ScrollState.underScrolling:
        tips = '边界滑动..';
        break;
      case ScrollState.underScrollEnd:
        tips = '达到边界';
        break;
      case ScrollState.underScrollRefreshing:
        tips = '正在刷新..';
        break;
      case ScrollState.underScrollRefreshDone:
        tips = '完成刷新';
        break;
      case ScrollState.underScrollCollapsing:
        tips = '正在收起...';
        break;
      case ScrollState.underScrollCollapseDone:
        tips = '处理完毕';
        break;
      case ScrollState.sliding:
        tips = '正在滑动..';
        break;
      default:
        tips = '...';
        break;
    }
    Widget child;
    if (scrollDirection == Axis.vertical) {
      child = Center(
        child: Text(
          tips,
          style: textStyle ??
              TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
        ),
      );
    } else {
      child = Center(
        child: SizedBox(
          width: 11,
          child: Text(
            tips,
            style: textStyle ??
                TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
          ),
        ),
      );
    }
    return _IndicatorHeaderView(
      headerSettings: headerSettings,
      headerNotifier: headerNotifier,
      textStyle: textStyle,
      child: child,
    );
  }
}

class _IndicatorFooterView extends InheritedWidget {
  _IndicatorFooterView(
      {required super.child,
      this.textStyle,
      this.footerSettings,
      this.footerNotifier});

  TextStyle? textStyle;
  FooterSettings? footerSettings;
  FooterNotifier? footerNotifier;

  @override
  bool updateShouldNotify(covariant _IndicatorFooterView oldWidget) {
    return textStyle != oldWidget.textStyle &&
        !(footerSettings != null &&
            footerSettings!.equalsTo(oldWidget.footerSettings));
  }
}

class SimpleFooterView extends StatelessWidget {
  const SimpleFooterView(
      {Key? key,
      this.textStyle,
      this.footerSettings,
      this.footerNotifier,
      this.scrollDirection})
      : super(key: key);

  final Axis? scrollDirection;
  final TextStyle? textStyle;

  final FooterSettings? footerSettings;
  final FooterNotifier? footerNotifier;

  @override
  Widget build(BuildContext context) {
    var tips = '';
    switch (footerNotifier?.scrollState) {
      case ScrollState.overScrolling:
        tips = '边界滑动..';
        break;
      case ScrollState.overScrollEnd:
        tips = '达到边界';
        break;
      case ScrollState.overScrollLoading:
        tips = '正在装载...';
        break;
      case ScrollState.overScrollLoadDone:
        tips = '完成装载';
        break;
      case ScrollState.overScrollCollapsing:
        tips = '正在收起...';
        break;
      case ScrollState.overScrollCollapseDone:
        tips = '处理完毕';
        break;
      case ScrollState.sliding:
        tips = '正在滑动..';
        break;
      default:
        tips = '...';
        break;
    }
    Widget child;
    if (scrollDirection == Axis.vertical) {
      child = Center(
        child: Text(
          tips,
          style: textStyle ??
              TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
        ),
      );
    } else {
      child = Center(
        child: SizedBox(
          width: 11,
          child: Text(
            tips,
            style: textStyle ??
                TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
          ),
        ),
      );
    }
    return _IndicatorFooterView(
      footerSettings: footerSettings,
      footerNotifier: footerNotifier,
      textStyle: textStyle,
      child: child,
    );
  }
}

class DotHeaderView extends StatelessWidget {
  DotHeaderView(
      {Key? key,
      this.headerNotifier,
      this.headerSettings,
      this.scrollDirection})
      : _color = ValueNotifier(Colors.grey[400]!),
        super(key: key);

  final Axis? scrollDirection;

  final HeaderSettings? headerSettings;
  final HeaderNotifier? headerNotifier;

  ValueNotifier<Color> _color;

  _startChangeColor() {
    Timer.periodic(
        const Duration(
          milliseconds: 200,
        ), (v) {
      if (headerNotifier?.scrollState != ScrollState.underScrollRefreshing) {
        v.cancel();
        return;
      }
      _color.value = (_color.value == Colors.grey[400]
          ? Colors.grey[200]
          : Colors.grey[400])!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (scrollDirection == Axis.vertical) {
      var dots = _renderDots();
      var currentSize = 25 + _calcDotLength(dotMinSize: 0, dotMaxSize: 6) * 2;
      child = Center(
        child: Container(
          height: 20,
          width: 60,
          // color: Colors.blueGrey,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              dots['middle']!,
              Positioned(
                left: currentSize,
                child: dots['first']!,
              ),
              Positioned(
                right: currentSize,
                child: dots['last']!,
              ),
            ],
          ),
        ),
      );
    } else {
      var dots = _renderDots();
      var currentSize = 25 + _calcDotLength(dotMinSize: 0, dotMaxSize: 6) * 2;
      child = Center(
        child: Container(
          height: 60,
          width: 20,
          // color: Colors.blueGrey,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              dots['middle']!,
              Positioned(
                top: currentSize,
                child: dots['first']!,
              ),
              Positioned(
                bottom: currentSize,
                child: dots['last']!,
              ),
            ],
          ),
        ),
      );
    }
    return child;
  }

  Map<String, Widget> _renderDots() {
    Widget first;
    Widget middle;
    Widget last;
    switch (headerNotifier?.scrollState) {
      case ScrollState.underScrollRefreshing:
        _startChangeColor();
        HapticFeedback.heavyImpact();
        first = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 6);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        break;
      case ScrollState.underScrollRefreshDone:
        HapticFeedback.heavyImpact();
        first = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 6);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        break;
      case ScrollState.underScrollCollapsing:
      case ScrollState.underScrollCollapseDone:
        first = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 6);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        break;
      case ScrollState.underScrolling:
      case ScrollState.underScrollEnd:
      case ScrollState.sliding:
      default:
        first = _renderDot(dotMinSize: 0, dotMaxSize: 4);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 8);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 4);
        break;
    }
    return {
      'first': first,
      'last': last,
      'middle': middle,
    };
  }

  Widget _renderDot({double dotMinSize = 2.0, double dotMaxSize = 10.0}) {
    var currentSize =
        _calcDotLength(dotMaxSize: dotMaxSize, dotMinSize: dotMinSize);
    return ValueListenableBuilder(
      valueListenable: _color,
      builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.only(
            left: scrollDirection == Axis.vertical ? currentSize : 0.0,
            right: scrollDirection == Axis.vertical ? currentSize : 0.0,
            top: scrollDirection == Axis.horizontal ? currentSize : 0.0,
            bottom: scrollDirection == Axis.horizontal ? currentSize : 0.0,
          ),
          child: SizedBox(
            width: currentSize,
            height: currentSize,
            child: CircleAvatar(
              backgroundColor: value,
            ),
          ),
        );
      },
    );
  }

  double _calcDotLength({double dotMinSize = 2.0, double dotMaxSize = 10.0}) {
    var currentSize = dotMinSize;

    ScrollMetrics? position = headerNotifier?.position;
    double currentPos = min((position?.pixels ?? 0.0).abs(),
        headerNotifier?.reservePixels ?? 40.00);
    var factor = (dotMaxSize - dotMinSize) /
        (headerNotifier?.reservePixels ?? 40.00).abs();
    currentSize = dotMinSize + currentPos.abs() * factor;
    return currentSize;
  }
}

class DotFooterView extends StatelessWidget {
  DotFooterView(
      {Key? key,
      this.footerSettings,
      this.footerNotifier,
      this.scrollDirection})
      : _color = ValueNotifier(Colors.grey[400]!),
        super(key: key);

  final Axis? scrollDirection;

  final FooterSettings? footerSettings;
  final FooterNotifier? footerNotifier;

  ValueNotifier<Color> _color;

  _startChangeColor() {
    Timer.periodic(
        const Duration(
          milliseconds: 200,
        ), (v) {
      if (footerNotifier?.scrollState != ScrollState.overScrollLoading) {
        v.cancel();
        return;
      }
      _color.value = (_color.value == Colors.grey[400]
          ? Colors.grey[200]
          : Colors.grey[400])!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (scrollDirection == Axis.vertical) {
      var dots = _renderDots();
      var currentSize = 25 + _calcDotLength(dotMinSize: 0, dotMaxSize: 6) * 2;
      child = Center(
        child: Container(
          height: 20,
          width: 60,
          // color: Colors.blueGrey,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              dots['middle']!,
              Positioned(
                left: currentSize,
                child: dots['first']!,
              ),
              Positioned(
                right: currentSize,
                child: dots['last']!,
              ),
            ],
          ),
        ),
      );
    } else {
      var dots = _renderDots();
      var currentSize = 25 + _calcDotLength(dotMinSize: 0, dotMaxSize: 6) * 2;
      child = Center(
        child: Container(
          height: 60,
          width: 20,
          // color: Colors.blueGrey,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              dots['middle']!,
              Positioned(
                top: currentSize,
                child: dots['first']!,
              ),
              Positioned(
                bottom: currentSize,
                child: dots['last']!,
              ),
            ],
          ),
        ),
      );
    }
    return child;
  }

  Map<String, Widget> _renderDots() {
    Widget first;
    Widget middle;
    Widget last;
    switch (footerNotifier?.scrollState) {
      case ScrollState.overScrollLoading:
        _startChangeColor();
        HapticFeedback.heavyImpact();
        first = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 6);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        break;
      case ScrollState.overScrollLoadDone:
        HapticFeedback.heavyImpact();
        first = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 6);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        break;
      case ScrollState.overScrollCollapsing:
      case ScrollState.overScrollCollapseDone:
        first = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 6);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 6);
        break;
      case ScrollState.overScrolling:
      case ScrollState.overScrollEnd:
      case ScrollState.sliding:
      default:
        first = _renderDot(dotMinSize: 0, dotMaxSize: 4);
        middle = _renderDot(dotMinSize: 1, dotMaxSize: 8);
        last = _renderDot(dotMinSize: 0, dotMaxSize: 4);
        break;
    }
    return {
      'first': first,
      'last': last,
      'middle': middle,
    };
  }

  Widget _renderDot({double dotMinSize = 2.0, double dotMaxSize = 10.0}) {
    var currentSize =
        _calcDotLength(dotMaxSize: dotMaxSize, dotMinSize: dotMinSize);
    return ValueListenableBuilder(
      valueListenable: _color,
      builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.only(
            left: scrollDirection == Axis.vertical ? currentSize : 0.0,
            right: scrollDirection == Axis.vertical ? currentSize : 0.0,
            top: scrollDirection == Axis.horizontal ? currentSize : 0.0,
            bottom: scrollDirection == Axis.horizontal ? currentSize : 0.0,
          ),
          child: SizedBox(
            width: currentSize,
            height: currentSize,
            child: CircleAvatar(
              backgroundColor: value,
            ),
          ),
        );
      },
    );
  }

  double _calcDotLength({double dotMinSize = 2.0, double dotMaxSize = 10.0}) {
    var currentSize = dotMinSize;

    ScrollMetrics? position = footerNotifier?.position;
    var maxScrollExtent=position?.maxScrollExtent??0.0;
    double currentPos = min(((position?.pixels ?? 0.0)-maxScrollExtent).abs(),
        footerNotifier?.reservePixels ?? 40.00);
    var factor = (dotMaxSize - dotMinSize) /
        (footerNotifier?.reservePixels ?? 40.00).abs();
    currentSize = dotMinSize + currentPos.abs() * factor;
    return currentSize;
  }
}
