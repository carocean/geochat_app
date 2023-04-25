import 'package:flutter/material.dart';

import '_app_surface.dart';
import '_page_context.dart';
import '_ultimate.dart';

typedef BuildPage = Widget Function(PageContext pageContext);
typedef BuildPages = List<LogicPage> Function(IServiceProvider site);

class LogicPage {
  LogicPage({
    required this.title,
    this.icon,
    this.subtitle,
    this.previousTitle,
    this.desc,
    required this.url,
    this.buildPage,
    this.buildRoute,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final String? previousTitle;
  final String? desc;
  final String url;

  ///注意：该参数存在并发访问问题。由于页面实例全局只有一个，当使用pagecontext.part(args)传参时，如果多次调用传不同的参数，则后面会将前面的覆盖掉，导致页面显示不正确，可使用pagecontext.argsOfPart替代
  final Map<String, Object> _parameters = {};

  ///构建页面。如果使用自定义动画则必须使用buildRoute，两个方法必有一个非空；当二者均有实现时则优先buildRoute
  final BuildPage? buildPage;

  ///构建路由。如果使用自定义动画则必须使用buildRoute，两个方法必有一个非空；当二者均有实现时则优先buildRoute
  final BuildRoute? buildRoute;

  @override
  String toString() {
    return '$runtimeType($title $url)';
  }

  Map<String, Object> get parameters => _parameters;
}

class Pageis extends InheritedWidget{
  Pageis({required super.child,required this.current,});
  PageContext current;
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    oldWidget as Pageis;
    return current != oldWidget.current;
  }

  static Pageis? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Pageis>();
  }
}