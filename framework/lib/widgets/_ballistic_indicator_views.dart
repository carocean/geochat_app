import 'dart:math';

import 'package:flutter/material.dart';
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
  const DotHeaderView(
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
    Widget child;
    if (scrollDirection == Axis.vertical) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _renderDotItems(),
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _renderDotItems(),
      );
    }
    return _IndicatorHeaderView(
      headerSettings: headerSettings,
      headerNotifier: headerNotifier,
      textStyle: textStyle,
      child: child,
    );
  }

  List<Widget> _renderDotItems() {
    var items = <Widget>[];

    // print('::::$currentSize');
    Widget first;
    Widget middle;
    Widget last;
    switch (headerNotifier?.scrollState) {
      case ScrollState.underScrollRefreshing:
      case ScrollState.underScrollRefreshDone:
      case ScrollState.underScrollCollapsing:
      case ScrollState.underScrollCollapseDone:
        first = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        middle = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        last = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        break;
      case ScrollState.underScrolling:
      case ScrollState.underScrollEnd:
      case ScrollState.sliding:
      default:
        first = _renderDot(dotMinSize: 2, dotMaxSize: 5);
        middle = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        last = _renderDot(dotMinSize: 2, dotMaxSize: 5);
        break;
    }
    items.add(first);
    items.add(middle);
    items.add(last);
    return items;
  }

  Widget _renderDot({double dotMinSize = 2.0, double dotMaxSize = 10.0}) {
    var currentSize = dotMinSize;

    ScrollMetrics? position = headerNotifier?.position;
    double currentPos = min((position?.pixels ?? 0.0).abs(),
        headerNotifier?.reservePixels ?? 40.00);
    var factor = (dotMaxSize - dotMinSize) /
        (headerNotifier?.reservePixels ?? 40.00).abs();
    currentSize = dotMinSize + currentPos.abs() * factor;

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
          backgroundColor: Colors.grey[400],
        ),
      ),
    );
  }
}


class DotFooterView extends StatelessWidget {
  const DotFooterView(
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
    Widget child;
    if (scrollDirection == Axis.vertical) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _renderDotItems(),
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _renderDotItems(),
      );
    }
    return _IndicatorFooterView(
      footerNotifier: footerNotifier,
      footerSettings: footerSettings,
      textStyle: textStyle,
      child: child,
    );
  }

  List<Widget> _renderDotItems() {
    var items = <Widget>[];

    // print('::::$currentSize');
    Widget first;
    Widget middle;
    Widget last;
    switch (footerNotifier?.scrollState) {
      case ScrollState.underScrollRefreshing:
      case ScrollState.underScrollRefreshDone:
      case ScrollState.underScrollCollapsing:
      case ScrollState.underScrollCollapseDone:
        first = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        middle = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        last = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        break;
      case ScrollState.underScrolling:
      case ScrollState.underScrollEnd:
      case ScrollState.sliding:
      default:
        first = _renderDot(dotMinSize: 2, dotMaxSize: 5);
        middle = _renderDot(dotMinSize: 2, dotMaxSize: 8);
        last = _renderDot(dotMinSize: 2, dotMaxSize: 5);
        break;
    }
    items.add(first);
    items.add(middle);
    items.add(last);
    return items;
  }

  Widget _renderDot({double dotMinSize = 2.0, double dotMaxSize = 10.0}) {
    var currentSize = dotMinSize;

    ScrollMetrics? position = footerNotifier?.position;
    double currentPos = min((position?.pixels ?? 0.0).abs(),
        footerNotifier?.reservePixels ?? 40.00);
    var factor = (dotMaxSize - dotMinSize) /
        (footerNotifier?.reservePixels ?? 40.00).abs();
    currentSize = dotMinSize + currentPos.abs() * factor;

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
          backgroundColor: Colors.grey[400],
        ),
      ),
    );
  }
}
