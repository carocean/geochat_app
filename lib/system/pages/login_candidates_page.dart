import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class UserCandidatesPage extends StatefulWidget {
  final PageContext context;

  const UserCandidatesPage({Key? key, required this.context}) : super(key: key);

  @override
  State<UserCandidatesPage> createState() => _UserCandidatesPageState();
}

class _UserCandidatesPageState extends State<UserCandidatesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BallisticSingleChildScrollView(
        display: _renderContent(),
        parentContext: context,
        positioneds: [
          Positioned(
              left: 15,
              right: 15,
              bottom: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.context.forward('/public/login');
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                            left: 10,
                          ),
                          child: Text(
                            '使用其它账号登录',
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
              )),
        ],
      ),
    );
  }

  _renderContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 96,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: const Text(
            '选择用户登录',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Wrap(
            spacing: 80,
            runSpacing: 25,
            direction: Axis.horizontal,
            children: [
              InkWell(
                onTap: () {
                  widget.context.forward('/workbench',
                      clearHistoryByPagePath: '.', scene: 'geotalk');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('lib/system/images/avatar.jpg'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '18023457655',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '点击进入',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  widget.context.forward('/workbench',
                      clearHistoryByPagePath: '.', scene: 'geotalk');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('lib/system/images/avatar1.jpg'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Andrew Joes',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '点击进入',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  widget.context.forward('/public/login/user');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('lib/system/images/avatar2.jpg'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '大道至简',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '需要密码登录',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
