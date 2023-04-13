import 'package:flutter/widgets.dart';

import '_app_surface.dart';

class AppNavigatorObserver extends NavigatorObserver {
  IAppSurface appSurface;
  Function() onswitchSceneOrTheme;
  final _histories = <_PageMemento>[];
  _PageMemento? _previous;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (_previous != null) {
      _histories.add(_previous!);
    }
    _previous = _PageMemento(
      sceneName: appSurface.current?.name ?? '',
      pageUrl: route.settings.name ?? '',
      theme: appSurface.current?.theme ?? '',
    );
//    print('--------$_previous');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    var memento = _histories.last;
    _histories.removeLast();
//    print('~~~~~~~$memento');
    ///当前移除的变成前进的先前，这类似于redo和todo，与push互为备忘
    _previous = memento;

    bool hasSwitch = false;
    if (memento.sceneName != appSurface.current?.theme) {
      appSurface.switchScene(memento.sceneName, memento.pageUrl);
      hasSwitch = true;
    } else {
      if (memento.theme != appSurface.current?.theme) {
        appSurface.switchTheme(memento.theme);
        hasSwitch = true;
      }
    }
    super.didPop(route, previousRoute);
    if (hasSwitch) {
      onswitchSceneOrTheme();
    }
  }

  AppNavigatorObserver(this.appSurface, this.onswitchSceneOrTheme);
}

class _PageMemento {
  String sceneName;
  String theme;
  String pageUrl;

  _PageMemento({
    required this.sceneName,
    required this.theme,
    required this.pageUrl,
  });

  @override
  String toString() {
    return '$pageUrl $sceneName $theme';
  }
}
