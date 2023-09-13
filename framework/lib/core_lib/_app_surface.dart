import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '_exceptions.dart';
import '_language.dart';
import '_page.dart';
import '_portal.dart';
import '_principal.dart';
import '_scene.dart';
import '_service_containers.dart';
import '_shared_preferences.dart';
import '_system.dart';
import '_theme.dart';
import '_ultimate.dart';
import '_window_task.dart';

typedef BuildRoute = ModalRoute Function(
    RouteSettings settings, LogicPage page, IServiceProvider site);
typedef AppDecorator = Widget Function(
    BuildContext, Widget, IServiceProvider site);
typedef OnGenerateRoute = Route<dynamic>? Function(RouteSettings);
typedef OnGenerateTitle = String Function(BuildContext);

class AppCreator {
  final String title;
  final String entrypoint;
  final String? defaultScene;
  final BuildSystem buildSystem;
  final BuildPortals buildPortals;
  final BuildServices buildServices;
  final Function()? onloading;
  final Function()? onloaded;
  final Map<String, dynamic> props;
  final ILocalPrincipal localPrincipal;
  final AppDecorator appDecorator;
  final bool? debugPaintSizeEnabled;
  final Map<String,String>? languageNameMapping;
  AppCreator({
    required this.title,
    required this.entrypoint,
    this.defaultScene,
    required this.buildSystem,
    required this.buildPortals,
    required this.buildServices,
    this.onloading,
    this.onloaded,
    required this.props,
    required this.localPrincipal,
    required this.appDecorator,
    this.debugPaintSizeEnabled,
    this.languageNameMapping,
  });
}

mixin IAppSurface {
  IScene? get current;

  TransitionBuilder? get appDecorator;

  Map<String, Widget Function(BuildContext)>? get routes;

  String get initialRoute;

  OnGenerateRoute get onGenerateRoute;

  OnGenerateTitle? get onGenerateTitle;

  Route<dynamic> Function(RouteSettings)? get onUnknownRoute;

  ThemeData? themeData(BuildContext context);

  Widget? get home;

  String? get title;

  Future<void> load(AppCreator creator);

  Future<void> switchScene(String scene, String pageUrl);

  Future<void> switchTheme(String theme);

  Future<void> switchLanguage(String languageCode, String? countryCode);
}

class DefaultAppSurface implements IAppSurface, IServiceProvider {
  late String _title;
  late String _entrypoint;
  late String _currentScene;
  final Map<String, IScene> _scenes = {};
  late TransitionBuilder _appDecorator;
  late ISharedPreferences _sharedPreferences;
  late ShareServiceContainer _shareServiceContainer;
  late ExternalServiceContainer _externalServiceProvider;
  final Map<String, dynamic> _props = {};

  @override
  IScene? get current => _scenes[_currentScene];

  @override
  TransitionBuilder get appDecorator {
    return _appDecorator;
  }

  @override
  String get title => _title;

  @override
  Widget? get home => null;

  @override
  ThemeData? themeData(BuildContext context) {
    var td = current?.getActivedThemeData(context);
    return td;
  }

  @override
  OnGenerateTitle? get onGenerateTitle {
    return null;
  }

  @override
  OnGenerateRoute get onGenerateRoute {
    return (settings) {
      String? path = settings?.name;
      if (StringUtil.isEmpty(path)) {
        return null;
      }
      if (!(current?.containsPage(path) ?? false)) {
        return null;
      }
      LogicPage? page = current?.getPage(path);
      if (page?.buildRoute == null) {
        return null;
      }
      return page?.buildRoute!(settings, page, _shareServiceContainer);
    };
  }

  @override
  Route Function(RouteSettings) get onUnknownRoute {
    return (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext buildContext) {
          return const ErrorPage404();
        },
      );
    };
  }

  @override
  String get initialRoute => _entrypoint;

  @override
  Map<String, Widget Function(BuildContext)> get routes => current?.pages ?? {};

  @override
  getService(String name) {
    if ('@.scene.current' == name) {
      return current;
    }
    if ('@.sharedPreferences' == name) {
      return _sharedPreferences;
    }
    if (name.startsWith('@.prop.')) {
      return _props[name];
    }
    return _externalServiceProvider.getService(name);
  }

  @override
  Future<void> load(AppCreator creator) async {
    _title = creator.title;
    _entrypoint = creator.entrypoint;
    _props.addAll(creator.props);

    BaseOptions options = BaseOptions(headers: {
      'Content-Type': "text/html; charset=utf-8",
    });
    var dio = Dio(options); //使用base配置可以通

    _shareServiceContainer = ShareServiceContainer(this);

    var principal = DefaultPrincipal();
    var widowTask = WindowTask();

    var language = DefaultLanguage(languageNames: creator.languageNameMapping);
    _shareServiceContainer.addServices(<String, dynamic>{
      '@.principal': principal,
      '@.http': dio,
      '@.app.creator': creator,
      '@.window.task': widowTask,
      '@.language': language,
    });

    _sharedPreferences = DefaultSharedPreferences();
    await _sharedPreferences.init(_shareServiceContainer);

    _appDecorator = (ctx, widget) {
      return creator.appDecorator(ctx, widget!, _shareServiceContainer);
    };

    var defaultScene = creator.defaultScene;
    if (StringUtil.isEmpty(defaultScene)) {
      defaultScene = IScene.DEFAULT_SCENE_NAME;
    }
    _currentScene = defaultScene!;

    await _buildExternalServices(creator.buildServices);
    await _buildSystem(creator.buildSystem);
    await _buildPortals(creator.buildPortals);
  }

  Future<void> _buildExternalServices(BuildServices buildServices) async {
    _externalServiceProvider = ExternalServiceContainer(null);
    var services = await buildServices(_shareServiceContainer);
    _externalServiceProvider.addServices(services);
    await _externalServiceProvider.initServices(services);
  }

  Future<void> _buildSystem(BuildSystem buildSystem) async {
    IScene scene = DefaultScene(
      name: _currentScene,
    );

    _scenes[_currentScene] = scene;

    var system = buildSystem(_shareServiceContainer);
    var pages = system?.buildPages!(_shareServiceContainer);
    var themeStyles = system?.buildThemes!(_shareServiceContainer);
    var shareServices = system.builderShareServices == null
        ? <String, dynamic>{}
        : await system.builderShareServices!(_shareServiceContainer);
    var sceneServices = system.builderSceneServices == null
        ? <String, dynamic>{}
        : await system.builderSceneServices!(_shareServiceContainer);

    _shareServiceContainer.addServices(shareServices);
    await _shareServiceContainer.initServices(shareServices);

    await scene.init(
      defaultTheme: system.defaultTheme,
      site: _shareServiceContainer,
      pages: pages ?? [],
      services: sceneServices,
      themeStyles: themeStyles ?? [],
    );
  }

  Future<void> _buildPortals(BuildPortals buildPortals) async {
    List<BuildPortal> portals = buildPortals(_shareServiceContainer);
    for (var buildPortal in portals) {
      var portal = buildPortal(_shareServiceContainer);

      IScene scene = DefaultScene(
        name: portal.id,
      );
      _scenes[portal.id] = scene;

      var pages = portal.buildPages == null
          ? <LogicPage>[]
          : portal.buildPages!(_shareServiceContainer);
      var themeStyles = portal.buildThemes == null
          ? <ThemeStyle>[]
          : portal.buildThemes!(_shareServiceContainer);
      var shareServices = portal.builderShareServices == null
          ? <String, dynamic>{}
          : await portal.builderShareServices!(_shareServiceContainer);
      var sceneServices = portal.builderSceneServices == null
          ? <String, dynamic>{}
          : await portal.builderSceneServices!(_shareServiceContainer);

      _shareServiceContainer.addServices(shareServices);
      await _shareServiceContainer.initServices(shareServices);

      await scene.init(
        defaultTheme: portal.defaultTheme,
        site: _shareServiceContainer,
        pages: pages,
        themeStyles: themeStyles,
        services: sceneServices,
      );
    }
  }

  @override
  Future<void> switchScene(String scene, String pageUrl) async {
    if (!_scenes.containsKey(scene)) {
      throw FlutterError('The switched scene does not exist: $scene}');
    }
    _currentScene = scene;
    await switchTheme(current?.theme);
  }

  @override
  Future<void> switchTheme(String? theme) async {
    IScene? scene = current;
    await scene?.switchTheme(theme!);
  }

  @override
  Future<void> switchLanguage(String languageCode, String? countryCode) async {
    IScene? scene = current;
    await scene?.switchLanguage(languageCode,countryCode);
  }
}
