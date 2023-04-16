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
  late List<Widget> _displays;
  late List<GeoBottomNavigationBarItem> _bottoms;

  GeotalkPartView get current => _views[_current];

  GeotalkPartViewDelegate({required this.pageController}) {
    _current = pageController.initialPage;
    _views = [];
    _bottoms = [];
    _displays = [];
  }

  List<Widget> get displays => _displays;

  List<GeoBottomNavigationBarItem> get bottoms => _bottoms;

  @override
  void dispose() {
    _current = 0;
    _views.clear();
    pageController.dispose();
  }

  void build(
      {required BuildContext context, required BuildPartViews buildPartViews}) {
    _views.clear();
    _bottoms.clear();
    _displays.clear();
    var views = buildPartViews(context);
    _views = views;
    for (var view in views) {
      _displays.add(view.display);
      _bottoms.add(view.bottom);
    }
  }

  void jumpToPartView(int index) {
    _current = index;
    pageController.jumpToPage(index);
  }
}
