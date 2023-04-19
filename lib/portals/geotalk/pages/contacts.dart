import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class ContactsPage extends StatefulWidget {
  final PageContext context;

  const ContactsPage({Key? key, required this.context}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  double _opacity = 1;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BallisticIndicatorSingleChildScrollView(
      parentContext: context,
      opacityListener: OpacityListener(
          opacityEvent: (opacity) {
            if (mounted) {
              setState(() {
                _opacity = opacity;
              });
            }
          },
          scrollHeight: 96,
          beginIsOpacity: _opacity == 1 ? false : true),
      display: Container(
        color: Colors.yellow,
        child: Column(
          children: _rendText(),
        ),
      ),
      positioneds: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            height: 10,
          ),
        ),
      ],
    );
  }

  _rendText() {
    List<Widget> items = [];
    items.add(TextField(
      decoration: InputDecoration(
        hintText: '输入',
      ),
    ));
    for (int i = 0; i < 60; i++) {
      items.add(
        Container(
          color: Colors.red.withOpacity(_opacity),
          child: Text('是一行:$i'),
        )
      );
    }
    items.add(TextField(
      decoration: InputDecoration(
        hintText: '输入',
      ),
    ));
    items.add(Container(
      height: 40,
      color: Colors.grey,
    ));
    return items;
  }
}
