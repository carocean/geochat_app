import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/framework.dart';

class RegisterPage extends StatefulWidget {
  final PageContext context;

  const RegisterPage({Key? key, required this.context}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
    return Scaffold(
      appBar: appBar,
      body: BallisticSingleChildScrollView(
        parentContext: context,
        isPushContentWhenKeyboardShow: true,
        appBarHeight: appBar.preferredSize.height,
        display: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '手机号注册',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          // image://上传图片后的预览填充到此
                        ),
                        child: const Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          IconData(0xe50f, fontFamily: 'triangle'),
                          size: 20,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '昵称',
                        ),
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
                            hintText: '例如：马斯克',
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
                  SizedBox(
                    height: 30,
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '国家/地区',
                        ),
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
                  SizedBox(
                    height: 30,
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '手机号',
                        ),
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
                  SizedBox(
                    height: 30,
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '密码',
                        ),
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
                            hintText: '填写密码',
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
                ],
              ),
              //为底部空出一些位置，不然底部上来会覆盖住上面内容
              const SizedBox(
                height: 220,
              ),
            ],
          ),
        ),
        positioneds: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 54,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 40,
                    right: 40,
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: false,
                        visualDensity: VisualDensity.compact,
                        groupValue: true,
                        fillColor: MaterialStateProperty.all(
                          Colors.grey[350],
                        ),
                        onChanged: (v) {},
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: '我已阅读并同意',
                            children: [
                              TextSpan(
                                text: '《软件许可及服务协议》',
                                style: TextStyle(
                                  color: Color(0xFF0061b0),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('....');
                                  },
                              ),
                              TextSpan(
                                text: '本页收集的信息仅用于注册账号',
                              ),
                            ],
                          ),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 40,
                    right: 40,
                  ),
                  child: Text(
                    '同意并继续',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
