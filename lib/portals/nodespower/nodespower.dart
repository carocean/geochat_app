import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/core_lib/_page.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:framework/core_lib/_portal.dart';
import 'package:framework/core_lib/_theme.dart';
import 'package:framework/core_lib/_ultimate.dart';
import 'package:geochat_app/portals/nodespower/pages/desktop_page.dart';
import 'package:geochat_app/portals/nodespower/styles/grey-styles.dart';

class NodesPowerPortal {
  Portal buildPortal(IServiceProvider site) {
    return Portal(
      id: 'nodespower',
      icon: Icons.add_chart,
      title: '广州节点动力信息科技有限公司框架',
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
              backgroundColor: const Color(0xFFF2F1F6),
              scaffoldBackgroundColor: const Color(0xFFF2F1F6),
              brightness: Brightness.light,
              appBarTheme: AppBarTheme.of(context).copyWith(
                color: const Color(0xFFF2F1F6),
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
              ),
            );
          },
        ),
      ],
      buildPages: (IServiceProvider site) => [
        LogicPage(
          title: '公司首页',
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
