import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:localization/generated/l10n.dart';

class DesktopPage extends StatefulWidget {
  final PageContext context;

  const DesktopPage({Key? key, required this.context}) : super(key: key);

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            widget.context.forward('/message',
                scene: 'geotalk', clearHistoryByPagePath: '.');
          },
          child: Text('这是桌面:${S.current.app_tile}'),
        ),
      ),
    );
  }
}
