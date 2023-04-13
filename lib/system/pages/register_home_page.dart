import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/core_lib/_page_context.dart';

import '../../common/Inertial_layout.dart';

class RegisterHomePage extends StatelessWidget {
  final PageContext context;

  const RegisterHomePage({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          this.context.backward();
        },
        icon: const Icon(
          Icons.clear,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('lib/system/images/entrypoint_bk.jpg'),
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.transparent,
        body: InertialLayout3(
          parentContext: context,
          appBar: appBar,
          display: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  this.context.forward('/public/register');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(
                              'lib/common/images/geochat_op.png',
                            ),
                            fit: BoxFit.contain),
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '地微注册',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 220,
              ),
            ],
          ),
          positionedList: [
            Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                ),
                child: Column(
                  children: [
                    const Text(
                      '以三方自动注册并登录',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6C6C6C),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Divider(
                        height: 1,
                        color: Color(0xFF555555),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            print('微信注册');
                          },
                          child: Column(
                            children: const [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  FontAwesomeIcons.weixin,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '微信',
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('支付宝登录注册');
                          },
                          child: Column(
                            children: const [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  FontAwesomeIcons.alipay,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                '支付宝',
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
