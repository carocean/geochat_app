import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/core_lib/_page.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:framework/core_lib/_portal.dart';
import 'package:framework/core_lib/_theme.dart';
import 'package:framework/core_lib/_ultimate.dart';
import 'package:geochat_app/portals/geophone/pages/desktop.dart';
import 'package:geochat_app/portals/geotalk/pages/messages.dart';
import 'package:localization/generated/l10n.dart';

import 'styles/grey-styles.dart';

class GeophonePortal {
  Portal buildPortal(IServiceProvider site) {
    return Portal(
      id: 'geophone',
      icon: Icons.add_chart,
      title: '效率风格',
      defaultTheme: '/grey',
      builderSceneServices: (site) async {
        return <String, dynamic>{};
      },
      builderShareServices: (site) async {
        return <String, dynamic>{};
      },
      buildThemes: (IServiceProvider site) => [
        ThemeStyle(
          title: '灰色',
          desc: '呈现淡灰色，接近白',
          url: '/grey',
          iconColor: Colors.grey[500],
          buildStyle: buildGreyStyles,
          buildTheme: (BuildContext context) {
            return ThemeData(
              backgroundColor: const Color(0xFFF5F5f5),
              scaffoldBackgroundColor: const Color(0xFFF5F5f5),
              brightness: Brightness.light,
              appBarTheme: AppBarTheme.of(context).copyWith(
                color: const Color(0xFFF5F5f5),
                textTheme: TextTheme(
                  titleMedium: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actionsIconTheme: IconThemeData(
                  color: Colors.grey[700],
                  opacity: 1,
                  size: 20,
                ),
                iconTheme: IconThemeData(
                  color: Colors.grey[700],
                  opacity: 1,
                  size: 20,
                ),
                elevation: 1.0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              primarySwatch: const MaterialColor(
                0xFFF5F5f5,
                {
                  50: Color(0xFFFAFAFA),
                  100: Color(0xFFF5F5F5),
                  200: Color(0xFFEEEEEE),
                  300: Color(0xFFE0E0E0),
                  400: Color(0xFFBDBDBD),
                  500: Color(0xFF9E9E9E),
                  600: Color(0xFF757575),
                  700: Color(0xFF616161),
                  800: Color(0xFF424242),
                  900: Color(0xFF212121),
                },
              ),
            );
          },
        ),
      ],
      buildPages: (IServiceProvider site) => [
        LogicPage(
          title: '效率风格首页',
          subtitle: '',
          icon: Icons.add,
          url: '/desktop',
          buildPage: (PageContext pageContext) => DesktopPage(
            context: pageContext,
          ),
        ),
      ],
    );
  }
}
