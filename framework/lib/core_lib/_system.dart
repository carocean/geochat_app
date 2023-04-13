

import '_page.dart';
import '_theme.dart';
import '_ultimate.dart';

typedef BuildSystem = System Function(IServiceProvider site);

class System {
  final String defaultTheme;
  final BuildThemes? buildThemes;
  final BuildPages ?buildPages;
  final BuildServices? builderShareServices;
  final BuildServices? builderSceneServices;
  System({
    required this.defaultTheme,
    required this.buildThemes,
    required this.buildPages,
    required this.builderShareServices,
    required this.builderSceneServices,
  });
}
