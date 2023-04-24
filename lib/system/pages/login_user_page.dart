import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/framework.dart';

enum _LoginMethod {
  password,
  msgCode,
  third, //如微信、支付宝等
}

class UserLoginPage extends StatefulWidget {
  final PageContext context;

  const UserLoginPage({Key? key, required this.context}) : super(key: key);

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  late _LoginMethod __loginMethod = _LoginMethod.password;

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
    Widget? display;
    switch (__loginMethod) {
      case _LoginMethod.password:
        display = _renderLoginByPassword();
        break;
      case _LoginMethod.msgCode:
        display = _renderLoginByMsgCode();
        break;
      case _LoginMethod.third:
        display = _renderLoginByThird();
        break;
    }
    return Scaffold(
      appBar: appBar,
      body: BallisticSingleChildScrollView(
        display: display!,
        isPushContentWhenKeyboardShow: true,
        positioneds: [
          Positioned(
            left: 15,
            right: 15,
            bottom: 0,
            child: Column(
              children: [
                __loginMethod == _LoginMethod.third
                    ? const SizedBox.shrink()
                    : SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.green,
                            ),
                          ),
                          child: const Text(
                            '登录',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                __loginMethod == _LoginMethod.third
                    ? const SizedBox.shrink()
                    : const SizedBox(
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
                    __loginMethod == _LoginMethod.third
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 15,
                          ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
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
                        const SizedBox(
                          height: 12,
                          child: VerticalDivider(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const Padding(
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
                        const SizedBox(
                          height: 12,
                          child: VerticalDivider(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              //不设为透明圆角出不来
                              builder: (context) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: widget.context.part(
                                      '/public/login/user/more', context)!,
                                );
                              },
                            ).then((value) {
                              if (value == null) {
                                return;
                              }
                              switch (value) {
                                case 'loginOtherAccount':
                                  widget.context.forward('/public/login');
                                  break;
                                default:
                                  break;
                              }
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                              right: 10,
                              left: 10,
                            ),
                            child: Text(
                              '更多选项',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0061b0),
                              ),
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
    );
  }

  _renderAvatar() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'lib/system/images/avatar.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          '+86 180 2345 7655',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Widget? _renderLoginByPassword() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _renderAvatar(),
        const SizedBox(
          height: 40,
        ),
        Column(
          children: [
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
                      __loginMethod = _LoginMethod.msgCode;
                    });
                  }
                },
                child: const Text(
                  '切换短信验证码登录',
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
          height: 160,
        ),
      ],
    );
  }

  Widget? _renderLoginByMsgCode() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _renderAvatar(),
        const SizedBox(
          height: 40,
        ),
        Column(
          children: [
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
                  child: Text('验证码'),
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
                      hintText: '输入验证码',
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
                SizedBox(
                  height: 25,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 0,
                          bottom: 0,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[300],
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      '获取验证码',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
                      __loginMethod = _LoginMethod.password;
                    });
                  }
                },
                child: const Text(
                  '切换密码登录',
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
          height: 160,
        ),
      ],
    );
  }

  Widget? _renderLoginByThird() {
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
                          __loginMethod = _LoginMethod.password;
                        });
                      }
                    },
                    child: const Text(
                      '切换密码登录',
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
                          __loginMethod = _LoginMethod.msgCode;
                        });
                      }
                    },
                    child: const Text(
                      '切换手机验证码登录',
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
