import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework/framework.dart';
import 'package:geochat_app/system/pages/login_candidates_page.dart';
import 'package:geochat_app/system/pages/login_page.dart';
import 'package:geochat_app/system/pages/entrypoint.dart';
import 'package:geochat_app/system/pages/register_home_page.dart';
import 'package:geochat_app/system/pages/login_user_page.dart';
import 'package:geochat_app/system/pages/welcome_page.dart';
import 'package:geochat_app/system/parts/login/login_settings_more_dialog.dart';

System buildSystem(IServiceProvider site) {
  return System(
    defaultTheme: '/grey',
    builderShareServices: (site) async {
      return <String, dynamic>{};
    },
    builderSceneServices: (site) async {
      return <String, dynamic>{};
    },
    buildThemes: buildThemes,
    buildPages: buildPages,
  );
}

List<ThemeStyle> buildThemes(site) {
  return <ThemeStyle>[
    ThemeStyle(
      title: '灰色',
      desc: '呈现淡灰色，接近白',
      url: '/grey',
      iconColor: Colors.grey[500],
      buildStyle: (site) {
        return <Style>[];
      },
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
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            toolbarTextStyle: TextTheme(
              titleMedium: TextStyle(
                color: Colors.grey[800],
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ).bodyMedium,
            titleTextStyle: TextTheme(
              titleMedium: TextStyle(
                color: Colors.grey[800],
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ).titleLarge,
          ),
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: const MaterialColor(
            0xFFF2F1F6,
            {
              50: Color(0xFFE8F5E9),
              100: Color(0xFFC8E6C9),
              200: Color(0xFFA5D6A7),
              300: Color(0xFF81C784),
              400: Color(0xFF66BB6A),
              500: Color(0xFF4CAF50),
              600: Color(0xFF43A047),
              700: Color(0xFF388E3C),
              800: Color(0xFF2E7D32),
              900: Color(0xFF1B5E20),
            },
          )).copyWith(background: const Color(0xFFF5F5f5)),
        );
      },
    ),
  ];
}

List<LogicPage> buildPages(site) {
  return <LogicPage>[
    LogicPage(
      title: '入口页面',
      subtitle: '',
      icon: Icons.settings,
      url: '/public/entrypoint',
      buildPage: (PageContext pageContext) => Entrypoint(
        context: pageContext,
      ),
    ),
    LogicPage(
      title: '登录',
      subtitle: '',
      icon: null,
      url: '/public/login',
      buildPage: (PageContext pageContext) => LoginPage(
        context: pageContext,
      ),
    ),
    LogicPage(
      title: '用户登录',
      subtitle: '',
      icon: null,
      url: '/public/login/user',
      buildPage: (PageContext pageContext) => UserLoginPage(
        context: pageContext,
      ),
    ),
    LogicPage(
      title: '候选登录',
      subtitle: '',
      icon: null,
      url: '/public/login/candidates',
      buildPage: (PageContext pageContext) => UserCandidatesPage(
        context: pageContext,
      ),
    ),
    LogicPage(
      title: '用户登录-更多选项',
      subtitle: '',
      icon: null,
      url: '/public/login/user/more',
      buildPage: (PageContext pageContext) => LoginSettingsMoreDialog(
        context: pageContext,
      ),
    ),
    LogicPage(
      title: '欢迎页',
      subtitle: '',
      icon: null,
      url: '/public/welcome',
      buildPage: (PageContext pageContext) => WelcomePage(
        context: pageContext,
      ),
    ),
    LogicPage(
      title: '注册的主页',
      subtitle: '',
      icon: null,
      url: '/public/register_home',
      buildPage: (PageContext pageContext) => RegisterHomePage(
        context: pageContext,
      ),
    ),
  ];
}
