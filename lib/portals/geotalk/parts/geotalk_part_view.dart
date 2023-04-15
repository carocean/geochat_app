import 'package:flutter/material.dart';
import 'package:framework/core_lib/_ultimate.dart';
import 'package:geochat_app/portals/geotalk/parts/bottom_navigation_bar.dart';

typedef BuildPartViews = List<GeotalkPartView> Function(BuildContext context);

class GeotalkPartView {
  AppBar? appBar;
  Widget display;
  GeoBottomNavigationBarItem bottom;

  GeotalkPartView({this.appBar, required this.display, required this.bottom});
}

class GeotalkPartViewDelegate implements IDisposable {
  late List<GeotalkPartView> _views;
  PageController pageController;
  late int _current;

  GeotalkPartView get current => _views[_current];

  GeotalkPartViewDelegate({required this.pageController}) {
    _current = pageController.initialPage;
    _views = [];
  }

  List<Widget> get displays => _views.map((e) => e.display).toList();

  List<GeoBottomNavigationBarItem> get bottoms =>
      _views.map((e) => e.bottom).toList();

  @override
  void dispose() {
    _current = 0;
    _views.clear();
    pageController.dispose();
  }

  void build(
      {required BuildContext context, required BuildPartViews buildPartViews}) {
    _views.clear();
    _views.addAll(buildPartViews(context));
  }

  void jumpToPartView(int index) {
    _current = index;
    pageController.jumpToPage(index);
  }
}
