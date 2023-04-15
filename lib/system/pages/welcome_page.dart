import 'package:flutter/material.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:geochat_app/common/Inertial_layout.dart';

class WelcomePage extends StatefulWidget {
  final PageContext context;

  const WelcomePage({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends InertialLayout2<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('lib/system/images/entrypoint_bk.jpg'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InertialLayoutWidget(
          parentContext: context,
          display: Container(
            height: 200,
          ),
          positioneds: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          child: const Text(
                            '登录',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            widget.context.forward("/public/login");
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: const Text(
                            '注册',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () {
                            widget.context.forward("/public/register/home");
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 34,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
