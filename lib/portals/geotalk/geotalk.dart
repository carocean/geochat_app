import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/core_lib/_page.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:framework/core_lib/_portal.dart';
import 'package:framework/core_lib/_theme.dart';
import 'package:framework/core_lib/_ultimate.dart';
import 'package:geochat_app/portals/geotalk/pages/contacts.dart';
import 'package:geochat_app/portals/geotalk/pages/discoveries.dart';
import 'package:geochat_app/portals/geotalk/pages/messages.dart';
import 'package:geochat_app/portals/geotalk/pages/mines.dart';
import 'package:geochat_app/portals/geotalk/workbench.dart';

import 'styles/grey-styles.dart';

class GeotalkPortal {
  Portal buildPortal(IServiceProvider site) {
    return Portal(
      id: 'geotalk',
      icon: Icons.add_chart,
      title: '地微聊天框架',
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
              scaffoldBackgroundColor: const Color(0xFFF2F1F6),
              brightness: Brightness.light,
              appBarTheme: AppBarTheme.of(context).copyWith(
                color: const Color(0xFFF2F1F6),
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
                systemOverlayStyle: SystemUiOverlayStyle.dark, toolbarTextStyle: TextTheme(
                  titleMedium: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ).bodyMedium, titleTextStyle: TextTheme(
                  titleMedium: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ).titleLarge,
              ), colorScheme: ColorScheme.fromSwatch(primarySwatch: const MaterialColor(
                0xFFF5F5f5,
                {
                  50: Color(0xFFFAFAFA),
                  100: Color(0xFFF2F1F6),
                  200: Color(0xFFEEEEEE),
                  300: Color(0xFFE0E0E0),
                  400: Color(0xFFBDBDBD),
                  500: Color(0xFF9E9E9E),
                  600: Color(0xFF757575),
                  700: Color(0xFF616161),
                  800: Color(0xFF424242),
                  900: Color(0xFF212121),
                },
              )).copyWith(background: const Color(0xFFF2F1F6)),
            );
          },
        ),
      ],
      buildPages: (IServiceProvider site) => [
        LogicPage(
          title: '聊天风格工作台',
          subtitle: '',
          url: '/workbench',
          buildPage: (PageContext pageContext) => GeotalkWorkBench(
            context: pageContext,
          ),
        ),
        LogicPage(
          title: '消息列表',
          subtitle: '',
          url: '/messages',
          buildPage: (PageContext pageContext) => MessagesPage(
            context: pageContext,
          ),
        ),
        LogicPage(
          title: '通讯录',
          subtitle: '',
          url: '/contacts',
          buildPage: (PageContext pageContext) => ContactsPage(
            context: pageContext,
          ),
        ),
        LogicPage(
          title: '发现',
          subtitle: '',
          url: '/discoveries',
          buildPage: (PageContext pageContext) => DiscoveriesPage(
            context: pageContext,
          ),
        ),
        LogicPage(
          title: '发现',
          subtitle: '',
          url: '/mines',
          buildPage: (PageContext pageContext) => MinesPage(
            context: pageContext,
          ),
        ),
      ],
    );
  }
}
