import 'package:flutter/cupertino.dart';
import 'package:framework/core_lib/_page_context.dart';

class ContactsPage extends StatefulWidget {
  final PageContext context;

  const ContactsPage({Key? key, required this.context}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
