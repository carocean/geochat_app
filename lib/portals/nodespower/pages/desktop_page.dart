import 'package:flutter/cupertino.dart';
import 'package:framework/core_lib/_page_context.dart';

class DesktopPage extends StatefulWidget {
  final PageContext context;

  const DesktopPage({Key? key, required this.context}) : super(key: key);

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
