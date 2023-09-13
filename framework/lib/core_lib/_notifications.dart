import 'package:flutter/material.dart';

class SwitchSceneNotification extends Notification {
  final String scene;
  final String pageUrl;
  final Function() ondone;

  SwitchSceneNotification({
    required this.scene,
    required this.pageUrl,
    required this.ondone,
  });
}

class SwitchThemeNotification extends Notification {
  final String theme;

  SwitchThemeNotification({
    required this.theme,
  });
}

class SwitchLanguageNotification extends Notification {
  final String languageCode;
  final String? countryCode;
  SwitchLanguageNotification({
    required this.languageCode,
    this.countryCode,
  });
}
