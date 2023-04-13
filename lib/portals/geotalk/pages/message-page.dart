import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:localization/generated/l10n.dart';

class MessagePage extends StatefulWidget {
  final PageContext context;

  const MessagePage({Key? key, required this.context}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            widget.context.forward('/desktop',
                clearHistoryByPagePath: '.', scene: 'geophone');
          },
          child: Text(
            '这是消息:${S.current.app_tile}',
            style: widget.context.style(
              '/message/test.text',
            ),
          ),
        ),
      ),
    );
  }
}
