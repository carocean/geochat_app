import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';

class ContactsPage extends StatefulWidget {
  final PageContext context;

  const ContactsPage({Key? key, required this.context}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  double _opacity = 1;
  Axis? _scrollDirection = Axis.vertical;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BallisticIndicatorSingleChildScrollView(
      parentContext: context,
      isPushContentWhenKeyboardShow: true,
      scrollDirection: _scrollDirection,
      appBarHeight: 80,
      navBarHeight: 50,
      headerSettings: HeaderSettings(
        scrollMode: IndicatorScrollMode.interact,
        reservePixels: 40,
        // buildChild: (settings, notify,scrollDirection) {
        //   return const Text('我来了');
        // },
        buildChild: (settings, notify, scrollDirection) {
          return DotHeaderView(
            textStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            scrollDirection: scrollDirection,
            headerSettings: settings,
            headerNotifier: notify,
          );
        },
        onRefresh: () async {
          await Future.delayed(
            const Duration(
              milliseconds: 4000,
            ),
          ).then((value) {
            print('========header refresh done.');
          });
        },
      ),
      footerSettings: FooterSettings(
        // scrollMode: IndicatorScrollMode.bouncing,
        reservePixels: 40,
        // buildChild: (settings, notify) {
        //   return const Text('我来了');
        // },
        onLoad: () async {
          await Future.delayed(
            Duration(
              milliseconds: 4000,
            ),
          ).then((value) {
            print('========footer load done.');
          });
        },
      ),
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
    items.add(SizedBox(
      height: 40,
    ));
    items.add(
      InkWell(
        onTap: () {
          setState(() {
            _scrollDirection = _scrollDirection == Axis.vertical
                ? Axis.horizontal
                : Axis.vertical;
          });
        },
        child: Text('排列：${_scrollDirection == Axis.vertical ? '垂直' : '水平'}'),
      ),
    );
    items.add(SizedBox(
      height: 40,
    ));
    for (int i = 0; i < 10; i++) {
      items.add(Container(
        color: Colors.red.withOpacity(_opacity),
        child: Text('是一行:$i'),
      ));
    }
    items.add(
      SizedBox(
        width: 200,
        child: TextField(
          decoration: InputDecoration(
            hintText: '输入',
          ),
        ),
      ),
    );
    items.add(Container(
      height: 40,
      color: Colors.grey,
    ));
    return items;
  }
}
