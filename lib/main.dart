import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:framework/framework.dart';
import 'package:geochat_app/system/system.dart';
import 'package:localization/generated/l10n.dart';

import 'portals/portals.dart';
void main() => platformRun(
      AppCreator(
          title: '地微',
          entrypoint: '/public/entrypoint',
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
            return viewport;
            // return Window(
            //   viewport: viewport,
            //   site: site,
            // );
          }),
    );

class Window extends StatefulWidget {
  final Widget viewport;
  final IServiceProvider site;

  const Window({super.key, required this.viewport, required this.site});

  @override
  State<Window> createState() => _WindowState();
}

class _WindowState extends State<Window> {
  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      widget.viewport,
    ];
    return Stack(
      fit: StackFit.loose,
      children: items,
    );
  }
}

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
