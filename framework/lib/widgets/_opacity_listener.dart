
import 'package:flutter/material.dart';

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
