import 'package:flutter/cupertino.dart';

import '_notifications.dart';
import '_page.dart';
import '_principal.dart';
import '_shared_preferences.dart';
import '_theme.dart';
import '_ultimate.dart';

class PageContext {
  final LogicPage page;
  final IServiceProvider site;
  final BuildContext context;
  final String sourceScene;
  final String sourceTheme;
  final Map<String, dynamic> partArgs;

  PageContext({
    required this.page,
    required this.sourceScene,
    required this.sourceTheme,
    required this.site,
    required this.context,
    this.partArgs = const <String, Object>{},
  });

  IPrincipal get principal => site.getService('@.principal');

  ///真实传过来的参数
  get parameters => ModalRoute.of(context)?.settings.arguments;

  ///真实传入的地址，特别是在part页中见到的地址实际上是其主页地址，而page才是part页
  String? get url => ModalRoute.of(context)?.settings.name;

  ///存储器
  ISharedPreferences sharedPreferences() {
    return site.getService('@.sharedPreferences');
  }

  ///当前场景，可能是框架id，也可能是系统场景名
  String currentScene() {
    return site.getService("@.scene.current")?.name;
  }

  ///当前主题url，为相对于框架的地址
  String currentTheme() {
    return site.getService("@.scene.current")?.theme;
  }

  style(String path) {
    if (!path.startsWith("/")) {
      throw FlutterError('路径没有以/开头');
    }
    Style styleDef = site.getService("@.style:$path");
    var style = styleDef.get();
    if (style == null) {
      throw FlutterError('样式未被发现:$path，在主题:${currentTheme()}');
    }
    return style;
  }

  ///部件作为页面的界面元素被嵌入，因此不支持页面跳转动画，因为它在调用时不被作为路由页。
  Widget? part(String pageUrl, BuildContext context,
      {Map<String, Object> arguments = const {}}) {
    String path = pageUrl;
    int pos = path.lastIndexOf('?');
    if (pos > 0) {
      String qs = path.substring(pos + 1, path.length);
      path = path.substring(0, pos);
      _parseQuerystringAndFillParams(qs, arguments);
    }
    LogicPage? page = site.getService("@.page:$path");
    if (page == null) return null;
    if (page.buildPage == null) {
      return null;
    }
    page.parameters.addAll(arguments);

    PageContext pageContext2 = PageContext(
      page: page,
      site: site,
      context: context,
      partArgs: arguments,
      sourceTheme: currentTheme(),
      sourceScene: currentScene(),
    );
    Widget p = page.buildPage!(pageContext2);
    var pageis=Pageis(
      $: pageContext2,
      child: p,
    );
    return pageis;
  }

  _parseQuerystringAndFillParams(qs, arguments) {
    while (qs.startsWith(' ')) {
      qs = qs.substring(1, qs.length);
    }
    if (StringUtil.isEmpty(qs)) {
      return;
    }
    int pos = qs.indexOf("&");
    String kv = '';
    if (pos < 0) {
      kv = qs;
      qs = '';
    } else {
      kv = qs.substring(0, pos);
      qs = qs.substring(pos + 1, qs.length);
    }
    pos = kv.indexOf('=');
    String k = '';
    String v = '';
    if (pos < 0) {
      k = kv;
      v = '';
    } else {
      k = kv.substring(0, pos);
      v = kv.substring(pos + 1, kv.length);
    }
    arguments[k] = v;
    if (!StringUtil.isEmpty(qs)) {
      _parseQuerystringAndFillParams(qs, arguments);
    }
  }

  LogicPage findPage(String url) {
    String path = url;
    int pos = path.lastIndexOf('?');
    if (pos > -1) {
      path = path.substring(0, pos);
    }
    return site.getService("@.page:$path");
  }

  ///@clearHistoryPageUrl 清除历史路由页，按路径前缀来匹配，如果是/表示清除所有历史
  ///                     注意：如果该参数非空将不能传递result参数给前页
  ///@result 放入返回给前页的结果
  bool backward({
     String? clearHistoryPageUrl,
    result,
  }) {
    NavigatorState state = Navigator.of(context);
    if (!state.canPop()) {
      return false;
    }
    if (StringUtil.isEmpty(clearHistoryPageUrl)) {
      state.pop(result);
      return true;
    }
    state.popUntil(
      _checkHistoryRoute(clearHistoryPageUrl!),
    );
    return true;
  }

  Future<T?> forward<T extends Object>(
    String pageUrl, {
    Map<String, Object>? arguments,

    ///如果为空在当前切景下跳转，如果要跳转的地址是其它框架的，则为框架id，输入/表示跳到系统场景
    String? scene,

    ///当参数scene不为空时可以使用该参数以接受跳转的返回值。在场景切换完成时回调,参数为回调结果
    Function(Object?)? onFinishedSwitchScene,

    ///如果为.号，表示替换当前路径为指定页
    String? clearHistoryByPagePath,
  }) async {
    var pagePath = pageUrl;
    int pos = pagePath.lastIndexOf('?');
    if (pos > -1) {
      pagePath = pagePath.substring(0, pos);
      var qs = pageUrl.substring(pos + 1);
      arguments ??= {};
      _parseQuerystringAndFillParams(qs, arguments);
    }

    if (StringUtil.isEmpty(scene)) {
      return _forward(pagePath,
          arguments: arguments, clearHistoryByPagePath: clearHistoryByPagePath);
    }
    SwitchSceneNotification(
        scene: scene!,
        pageUrl: pagePath,
        ondone: () async {
          _forward(pagePath,
                  arguments: arguments,
                  clearHistoryByPagePath: clearHistoryByPagePath)
              .then((result) {
            if (onFinishedSwitchScene != null) {
              onFinishedSwitchScene(result);
            }
          });
        }).dispatch(context);
    return null;
  }

  Future<T?> _forward<T extends Object>(
    String pagePath, {
    Map<String, Object>? arguments,
    String? clearHistoryByPagePath,
  }) {
    arguments ??= {};
    if (!StringUtil.isEmpty(clearHistoryByPagePath)) {
      if ('.' == clearHistoryByPagePath) {
        return Navigator.of(context).pushReplacementNamed(
          pagePath,
          arguments: arguments,
        );
      }
      return Navigator.of(context).pushNamedAndRemoveUntil(
        pagePath,
        _checkHistoryRoute(clearHistoryByPagePath!),
        arguments: arguments,
      );
    }
    return Navigator.pushNamed(
      context,
      pagePath,
      arguments: arguments,
    );
  }

  void switchTheme(String url) {
    SwitchThemeNotification(theme: url).dispatch(context);
  }

  RoutePredicate _checkHistoryRoute(String url) {
    return (Route<dynamic> route) {
      return !route.willHandlePopInternally &&
          route is ModalRoute &&
          _checkUrl(route, url);
    };
  }

  bool _checkUrl(ModalRoute route, String url) {
    String name = route.settings.name ?? '';
    if (StringUtil.isEmpty(name)) {
      return false;
    }
    if (name == '/') {
      //保留桌面不被清除
      return true;
    }
    return !name.startsWith(url);
  }
}
