import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_page.dart';
import '_page_context.dart';
import '_principal.dart';
import '_service_containers.dart';
import '_shared_preferences.dart';
import '_theme.dart';
import '_ultimate.dart';

mixin IScene implements IDisposable {
  static const DEFAULT_SCENE_NAME = '/';

  String get name;

  IPrincipal get principal;

  String get defaultTheme;

  String get theme;

  IServiceProvider get site;

  Map<String, Widget Function(BuildContext)> get pages;

  ThemeData? getActivedThemeData(BuildContext context);

  Future<void> switchTheme(String theme) async {}

  Future<void> init({
    required IServiceProvider site,
    required Map<String, dynamic> services,
    required List<LogicPage> pages,
    required String defaultTheme,
    required List<ThemeStyle> themeStyles,
  });

  bool containsPage(String? path);

  LogicPage? getPage(String? path);
}

class DefaultScene implements IScene, IServiceProvider {
  static const _THEME_STORE_KEY = '#theme';

  @override
  final String name;
  late String _defaultTheme;
  final Map<String, LogicPage> _pages = {};
  final Map<String, _ThemeEntity> _themeStyles = {};
  late IServiceProvider parentSite;
  late SceneServiceContainer _sceneServiceContainer;

  DefaultScene({
    required this.name,
  });

  @override
  IServiceProvider get site => this;

  @override
  bool containsPage(String? path) {
    return _pages.containsKey(path);
  }

  @override
  LogicPage? getPage(String? path) {
    return _pages[path];
  }

  @override
  getService(String name) {
    if (name.startsWith('@.page:')) {
      String path = name.substring('@.page:'.length, name.length);
      return _pages[path];
    }
    if ('@.theme.names' == name) {
      return _themeStyles.keys;
    }
    if (name.startsWith('@.theme:')) {
      String path = name.substring('@.theme:'.length, name.length);
      return _themeStyles[path]?.define;
    }
    if (name.startsWith('@.style:')) {
      var themeEntity = _themeStyles[theme];
      String path = name.substring('@.style:'.length, name.length);
      return themeEntity?.styles[path];
    }

    return parentSite.getService(name);
  }

  @override
  Future<void> init({
    required IServiceProvider site,
    required Map<String, dynamic> services,
    required List<LogicPage> pages,
    required String defaultTheme,
    required List<ThemeStyle> themeStyles,
  }) async {
    parentSite = site;
    _sceneServiceContainer = SceneServiceContainer(this);
    _sceneServiceContainer.addServices(services);

    for (var page in pages) {
      if (_pages.containsKey(page.url)) {
        throw FlutterErrorDetails(exception: Exception('已存在地址页:${page.url}'));
      }
      _pages[page.url] = page;
    }

    for (var _theme_ in themeStyles) {
      if (_themeStyles.containsKey(_theme_.url)) {
        throw FlutterErrorDetails(exception: Exception('已存在主题:${_theme_.url}'));
      }
      var styles = _theme_.buildStyle(_sceneServiceContainer);
      var index = <String, Style>{};
      for (var style in styles) {
        if (index.containsKey(style.url)) {
          throw FlutterErrorDetails(
              exception: Exception('主题:${_theme_.url}中已存在样式${_theme_.url}'));
        }
        index[style.url] = style;
      }
      var theme = _ThemeEntity(
          themeUrl: _theme_.url,
          styles: index,
          buildTheme: _theme_.buildTheme,
          define: _theme_);
      _themeStyles[_theme_.url] = theme;
    }
    if (StringUtil.isEmpty(defaultTheme) && themeStyles.isNotEmpty) {
      defaultTheme = themeStyles.first.url ;
    }
    _defaultTheme = defaultTheme;

    ///如果没有设置过主题，且默认有主题则设置主题
    if (StringUtil.isEmpty(theme) && !StringUtil.isEmpty(defaultTheme)) {
      await _setTheme(themeStyles[0].url);
    }
    _sceneServiceContainer.initServices(services);

    return ;
  }

  @override
  Map<String, Widget Function(BuildContext)> get pages {
    var map = <String, Widget Function(BuildContext)>{};
    for (var key in _pages.keys) {
      var page = _pages[key];
      if (page?.buildPage == null) {
        continue;
      }
      map[key] = (context) {
        var pageContext = PageContext(
            page: page!,
            sourceScene: name,
            sourceTheme: theme,
            site: _sceneServiceContainer,
            context: context);
        //支持两种构建页的api。
        //一种是传统方式，页组件要在构造中传入 pageContext
        //一种是通过 PageIs.of 的方式该问 pageContext
        var p = page.buildPage!(pageContext);
        var pageis=Pageis(
          current: pageContext,
          child: p,
        );
        return pageis;
      };
    }
    return map;
  }

  @override
  // TODO: implement principal
  IPrincipal get principal => parentSite.getService('@.principal');

  @override
  void dispose() {
    _pages.clear();
    _themeStyles.clear();
  }

  @override
  ThemeData? getActivedThemeData(BuildContext context) =>
      _themeStyles[theme]?.buildTheme(context);

  @override
  String get theme {
    ISharedPreferences sharedPreferences =
        parentSite.getService('@.sharedPreferences');
    String? theme = sharedPreferences.getString(_THEME_STORE_KEY,
        person: principal.openId, scene: name);
    if (StringUtil.isEmpty(theme)) {
      theme = _defaultTheme;
    }
    return theme!;
  }

  @override
  Future<void> switchTheme(String theme) async {
    if (!_themeStyles.containsKey(theme)) {
      throw FlutterError('场景:$name下不存在主题:$theme');
    }
    await _setTheme(theme);
    return;
  }

  _setTheme(String theme) async {
    ISharedPreferences sharedPreferences =
        parentSite.getService('@.sharedPreferences');
    await sharedPreferences.setString(_THEME_STORE_KEY, theme,
        person: principal.openId, scene: name);
  }

  @override
  // TODO: implement defaultTheme
  String get defaultTheme => _defaultTheme;
}

class _ThemeEntity {
  String themeUrl;
  Map<String, Style> styles = {};
  BuildTheme buildTheme;
  ThemeStyle define;

  _ThemeEntity({
    required this.themeUrl,
    required this.styles,
    required this.buildTheme,
    required this.define,
  });
}
