import 'package:framework/framework.dart';
import 'package:geochat_app/system/system.dart';

import 'portals/portals.dart';
void main() => platformRun(
      AppCreator(
          title: '地微',
          entrypoint: '/public/entrypoint',
          debugPaintSizeEnabled: false,
          languageNameMapping:{
            "en":"English",
            "en_US":"English USA",
            "zh":"中文",
            "zh_CN":"中文简体",
          },
          props: {
            ///默认应用，即终端未指定应用号时登录或注册的目标应用
          },
          buildServices: (site) async {
            return {};
          },
          buildSystem: buildSystem,
          buildPortals: buildPortals,
          localPrincipal: DefaultLocalPrincipal(),

          ///以下可装饰窗口区，比如在device连接状态改变时提醒用户
          appDecorator: (ctx, viewport, site) {
           var windowTask= site.getService('@.window.task');
            // return viewport;
            return Window(
              viewport: viewport,
              windowTask: windowTask,
            );
          }),
    );



class DefaultLocalPrincipal implements ILocalPrincipal {
  late ILocalPrincipalVisitor _visitor;

  @override
  String current() {
    return _visitor.current();
  }

  @override
  IPrincipal get(String person) {
    return _visitor.get(person);
  }

  @override
  void setVisitor(ILocalPrincipalVisitor visitor) {
    _visitor = visitor;
  }
}
