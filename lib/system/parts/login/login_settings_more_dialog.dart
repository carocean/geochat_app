import 'package:flutter/material.dart';
import 'package:framework/core_lib/_page_context.dart';

class LoginSettingsMoreDialog extends StatelessWidget {
  final PageContext context;

  const LoginSettingsMoreDialog({Key? key, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F1F6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: (){
              this.context.backward(result: 'loginOtherAccount');
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              color: Colors.white,
              child: Center(
                child: Text(
                  '登录其它账号',
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            color: Colors.white,
            child: Center(
              child: Text(
                '前往安全中心',
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            color: Colors.white,
            child: Center(
              child: Text(
                '注册',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: (){
              this.context.backward(result: 'close');
            },
            child: Container(
              padding: EdgeInsets.only(
                bottom: 34,
                top: 20,
              ),
              color: Colors.white,
              child: Center(
                child: Text('取消'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
