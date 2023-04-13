import 'package:flutter/material.dart';

import '_ultimate.dart';

typedef BuildTheme = ThemeData Function(BuildContext context);
typedef BuildStyle = List<Style> Function(IServiceProvider site);
typedef BuildThemes = List<ThemeStyle> Function(IServiceProvider site);

class ThemeStyle {
  final String url;
  final String title;
  final String? desc;
  final Color? iconColor;
  final BuildTheme buildTheme;
  final BuildStyle buildStyle;

  const ThemeStyle({
    required this.title,
    required this.url,
    this.desc,
    this.iconColor,
    required this.buildTheme,
    required this.buildStyle,
  });
}

typedef GetStyle = Function();

class Style {
  final String url;
  final String? desc;
  final GetStyle get;

  const Style({
    required this.url,
    this.desc,
    required this.get,
  });
}
