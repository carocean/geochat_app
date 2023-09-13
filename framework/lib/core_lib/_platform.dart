import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:framework/core_lib/_language.dart';
import 'package:localization/generated/l10n.dart';

import '_app_surface.dart';
import '_navigator_observers.dart';
import '_notifications.dart';
import '_ultimate.dart';

final IAppSurface _appSurface = DefaultAppSurface();

void platformRun(AppCreator creator) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isAndroid) {
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
    _PlatformApp(debugPaintSizeEnabled: creator.debugPaintSizeEnabled),
  );
}

class _PlatformApp extends StatefulWidget {
  bool? debugPaintSizeEnabled;

  _PlatformApp({this.debugPaintSizeEnabled});

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
  void didUpdateWidget(covariant _PlatformApp oldWidget) {
    if (oldWidget.debugPaintSizeEnabled != widget.debugPaintSizeEnabled) {
      oldWidget.debugPaintSizeEnabled = widget.debugPaintSizeEnabled;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = widget.debugPaintSizeEnabled ?? false;
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
        if (notification is SwitchLanguageNotification) {
          if (!StringUtil.isEmpty(notification.languageCode)) {
            _appSurface
                .switchLanguage(
                    notification.languageCode, notification.countryCode)
                .then((v) {
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
        locale: _appSurface.current?.locale,
        localeResolutionCallback: (locale, supportedLocales) {
          IServiceProvider provider = _appSurface.current as IServiceProvider;
          var language = provider.getService('@.language') as ILanguage;
          language.load(supportedLocales);

          var result = supportedLocales
              .where((element) => element.languageCode == locale?.languageCode);
          if (result.isNotEmpty) {
            return locale;
          }
          return const Locale('en');
        },
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

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {}
}
