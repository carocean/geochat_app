import 'package:flutter/cupertino.dart';
import 'package:framework/core_lib/_page_context.dart';

class DiscoveriesPage extends StatefulWidget {
  final PageContext context;

  const DiscoveriesPage({Key? key, required this.context}) : super(key: key);

  @override
  State<DiscoveriesPage> createState() => _DiscoveriesPageState();
}

class _DiscoveriesPageState extends State<DiscoveriesPage> with AutomaticKeepAliveClientMixin{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
