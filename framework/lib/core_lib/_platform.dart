import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/generated/l10n.dart';

import '_app_surface.dart';
import '_navigator_observers.dart';
import '_notifications.dart';
import '_ultimate.dart';

final IAppSurface _appSurface = DefaultAppSurface();

void platformRun(AppCreator creator) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  if (creator.onloading != null) {
    creator.onloading!();
  }

  await _appSurface.load(creator);

  if (creator.onloaded != null) {
    creator.onloaded!();
  }
  runApp(
    _PlatformApp(),
  );
}

class _PlatformApp extends StatefulWidget {
  @override
  __PlatformAppState createState() => __PlatformAppState();
}

class __PlatformAppState extends State<_PlatformApp> {
  AppNavigatorObserver? _appNavigatorObserver;

  @override
  void initState() {
    super.initState();
    _appNavigatorObserver = AppNavigatorObserver(_appSurface, () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _appNavigatorObserver = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is SwitchSceneNotification) {
          _appSurface
              .switchScene(notification.scene, notification.pageUrl)
              ?.then((v) {
              WidgetsBinding.instance.addPostFrameCallback((d) {
                notification.ondone();
              });
            setState(() {});
          });
          return false;
        }
        if (notification is SwitchThemeNotification) {
          if (!StringUtil.isEmpty(notification.theme)) {
            _appSurface.switchTheme(notification.theme)?.then((v) {
              setState(() {});
            });
          } else {
            setState(() {});
          }
          return false;
        }
        return true;
      },
      child: MaterialApp(
        title: _appSurface.title ?? '',
        builder: _appSurface.appDecorator,
        routes: _appSurface.routes ?? {},
        initialRoute: _appSurface.initialRoute,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: _appSurface.onUnknownRoute,
        onGenerateTitle: _appSurface.onGenerateTitle,
        theme: _appSurface.themeData(context),
        home: _appSurface.home,
        navigatorObservers: [
          _appNavigatorObserver!,
        ],
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
  Route<dynamic>? onGenerateRoute(RouteSettings settings){

  }
}
