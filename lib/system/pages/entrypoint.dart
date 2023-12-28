import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/core_lib/_page.dart';
import 'package:framework/core_lib/_page_context.dart';

class Entrypoint extends StatefulWidget {
  final PageContext context;

  const Entrypoint({Key? key, required this.context}) : super(key: key);

  @override
  State<Entrypoint> createState() => _EntrypointState();
}

class _EntrypointState extends State<Entrypoint> {
  @override
  void initState() {
    _checkEntrypoint().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  Future<void> _checkEntrypoint() async {
    int _entrymode = 3; //0=welcome页（本地无用户）；1=本地有且仅有一个用户但令牌也过期了；2=进入本地多用户选择页（多个用户不论令牌是否有未过期的均列出）；3=进入桌面（本地有用户且令牌不过期）
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (_entrymode) {
        case 0: //本地无用户则跳到welcome
          widget.context.forward('/public/welcome', clearHistoryByPagePath: '.');
          break;
        case 1: //本地有且仅有一个用户但令牌也过期了进入有用户登录页
          widget.context.forward('/public/login/user', clearHistoryByPagePath: '.');
          break;
        case 2: //多个用户不论令牌是否有未过期的均列出，进入本地多用户选择页
          widget.context.forward('/public/login/candidates', clearHistoryByPagePath: '.');
          break;
        default: //进入桌面
          // Pageis.of(context)?.$.forward('/workbench',
          //     clearHistoryByPagePath: '/public', scene: 'geotalk');
        Pageis.of(context)?.$.forward('/workbench',
            clearHistoryByPagePath: '/public', scene: 'geophone');
          break;
      }
    });

    //成功则到桌面,检测到本地有token且没过期则直接跳转到场景首页
    // WidgetsBinding.instance.addPostFrameCallback((d) {
    //   widget.context.forward(
    //     "/",
    //     clearHistoryByPagePath: '/public/',
    //     scene: widget.context.principal.portal??'gbera',
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('lib/system/images/entrypoint_bk.jpg'),
        ),
      ),
    );
  }
}
