import 'package:flutter/material.dart';

import '_page.dart';
import '_theme.dart';
import '_ultimate.dart';


typedef BuildPortals = List<BuildPortal> Function(IServiceProvider site);
typedef BuildPortal = Portal Function(IServiceProvider site);

class Portal {
  const Portal({
    required this.id,
    required this.title,
    required this.icon,
    required this.defaultTheme,
    required this.buildPages,
    required this.buildThemes,
    required this.builderSceneServices,
    required this.builderShareServices,
  });

  final BuildServices? builderShareServices;
  final BuildServices? builderSceneServices;
  final BuildThemes? buildThemes;
  final BuildPages? buildPages;
  final String id;
  final String defaultTheme;
  final String title;
  final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Portal typedOther = other;
    return typedOther.id == id &&
        typedOther.title == title &&
        typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(id, title, icon);

  @override
  String toString() {
    return '$runtimeType($id)';
  }
}
