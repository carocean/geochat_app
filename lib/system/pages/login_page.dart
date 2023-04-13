import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:geochat_app/common/Inertial_layout.dart';

enum _LoginMethod {
  phone,
  account,
  third, //如微信、支付宝等
}

class LoginPage extends StatefulWidget {
  final PageContext context;

  const LoginPage({Key? key, required this.context}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// 布局说明:<br>
/// 1、界面边界滑动有惯性<br>
/// 2、在滚动组件中如何将组件放到底部<br>
/// 3、底部随键盘上推时，上推到一定位置，则上部上滑。<br>
/// 布局实现：<br>
/// 1、实现界面边界滑动有惯性：<br>
/// physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),<br>
/// 2、在滚动组件中如何将组件放到底部<br>
/// 首先SingleChildScrollView想要充满屏（默认只有内容高度），需要将其套在SizedBox.expand中。<br>
/// 但这样只是使得SingleChildScrollView组件框框占了满屏，可以在屏任意位置感受边界惯性滑到效果了。<br>
/// 而其内如想将内容区域满屏，则需要套一个ConstrainedBox组件，其constraints: BoxConstraints(minHeight: scrollViewHeight),<br>
/// 其中scrollViewHeight高度是屏幕内容高度-状态栏高度-标题栏高度-键盘高度。键盘高度要么为0要么是出现时的高度。<br>
/// 3、实现底部随键盘上推时，上推到一定位置，则上部上滑。
/// 内套一个Stack组件，以Positioned放置底部组件。但为了在键盘出现时不压主内容，可在主内容下方补高度，如用SizeBox。<br>
/// 然后用SingleChildScrollView的滚动控制器，当键盘高度更新时，触发该滚动控件滚动到底部。<br>
///
/// @see Geochat/LoginPage
///
class _LoginPageState extends InertialLayout<LoginPage> {

  late _LoginMethod __loginMethod = _LoginMethod.phone;


  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          widget.context.backward();
        },
        icon: const Icon(
          Icons.clear,
          size: 18,
        ),
      ),
    );
    var scrollViewHeight = super.scrollViewHeight(appBar);

    Widget? display;
    switch (__loginMethod) {
      case _LoginMethod.phone:
        display = _renderLoginByPhone();
        break;
      case _LoginMethod.account:
        display = _renderLoginByAccount();
        break;
      case _LoginMethod.third:
        display = _renderLoginByThird();
        break;
    }
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: scrollViewHeight),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  display!,
                  Positioned(
                    left: 15,
                    right: 15,
                    bottom: 0,
                    child: Column(
                      children: [
                        __loginMethod == _LoginMethod.third
                            ? const SizedBox.shrink()
                            : Text(
                                _getNote(),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                        __loginMethod == _LoginMethod.third
                            ? const SizedBox.shrink()
                            : const SizedBox(
                                height: 15,
                              ),
                        __loginMethod == _LoginMethod.third
                            ? const SizedBox.shrink()
                            : ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.green,
                                  ),
                                ),
                                child: const Text(
                                  '同意并继续',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            __loginMethod == _LoginMethod.third
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          __loginMethod = _LoginMethod.third;
                                        });
                                      }
                                    },
                                    child: const Text(
                                      '用微信/支付宝登录',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0061b0),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: Text(
                                    '找回密码',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0061b0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                  child: VerticalDivider(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                  ),
                                  child: Text(
                                    '紧急冻结',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0061b0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                  child: VerticalDivider(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                  ),
                                  child: Text(
                                    '安全中心',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0061b0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 34,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getNote() {
    switch (__loginMethod) {
      case _LoginMethod.phone:
        return '上述手机号仅用于登录验证';
      case _LoginMethod.account:
        return '上述地微号/邮箱仅用于登录验证';
      default:
        return '';
    }
  }

  Widget _renderLoginByPhone() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: const Text(
            '手机号登录',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('国家/地区'),
                ),
                Expanded(
                  child: Text(
                    '中国大陆（+86）',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('手机号'),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    // autofocus: true,
                    // obscureText: true,
                    cursorHeight: 20,
                    cursorColor: Colors.blue,
                    showCursor: true,
                    decoration: InputDecoration(
                      isCollapsed: true, //收缩，不然高度上下有边空
                      border: InputBorder.none,
                      hintText: '请填写手机号',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      __loginMethod = _LoginMethod.account;
                    });
                  }
                },
                child: const Text(
                  '用地微号/邮箱登录',
                  style: TextStyle(
                    color: Color(0xFF0061b0),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 220,
        ),
      ],
    );
  }

  Widget _renderLoginByAccount() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: const Text(
            '地微号/邮箱登录',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('账号'),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    // autofocus: true,
                    // obscureText: true,
                    cursorHeight: 20,
                    cursorColor: Colors.blue,
                    showCursor: true,
                    decoration: InputDecoration(
                      isCollapsed: true, //收缩，不然高度上下有边空
                      border: InputBorder.none,
                      hintText: '请填写地微号/邮箱',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('密码'),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    // autofocus: true,
                    // obscureText: true,
                    cursorHeight: 20,
                    cursorColor: Colors.blue,
                    showCursor: true,
                    decoration: InputDecoration(
                      isCollapsed: true, //收缩，不然高度上下有边空
                      border: InputBorder.none,
                      hintText: '请填写密码',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      __loginMethod = _LoginMethod.phone;
                    });
                  }
                },
                child: const Text(
                  '用手机号登录',
                  style: TextStyle(
                    color: Color(0xFF0061b0),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 220,
        ),
      ],
    );
  }

  Widget _renderLoginByThird() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: const Text(
            '三方登录',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.weixin,
                      color: Colors.green,
                      size: 50,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '微信',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 50,
                    right: 50,
                  ),
                  child: SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.alipay,
                      color: Colors.blue,
                      size: 50,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '支付宝',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 90,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 15,
                  ),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          __loginMethod = _LoginMethod.phone;
                        });
                      }
                    },
                    child: const Text(
                      '用手机号登录',
                      style: TextStyle(
                        color: Color(0xFF0061b0),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          __loginMethod = _LoginMethod.account;
                        });
                      }
                    },
                    child: const Text(
                      '用地微号/邮箱登录',
                      style: TextStyle(
                        color: Color(0xFF0061b0),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 200,
        ),
      ],
    );
  }
}
