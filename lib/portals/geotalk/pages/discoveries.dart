import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';

class DiscoveriesPage extends StatefulWidget {
  final PageContext context;

  const DiscoveriesPage({Key? key, required this.context}) : super(key: key);

  @override
  State<DiscoveriesPage> createState() => _DiscoveriesPageState();
}

class _DiscoveriesPageState extends State<DiscoveriesPage>
    with AutomaticKeepAliveClientMixin {
  double _opacity = 1;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BallisticIndicatorNestedScrollView(
      parentContext: context,
      isPushContentWhenKeyboardShow: true,
      // scrollDirection: Axis.horizontal,
      headerSettings: HeaderSettings(
          reservePixels: 40.00,
          scrollMode: IndicatorScrollMode.interact,
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 4000)).then((value) {
              print('::::head refreshed.');
            });
          },
          buildChild: (settings, notify, scrollDirection) {
            return DotHeaderView(
              headerSettings: settings,
              headerNotifier: notify,
              scrollDirection: scrollDirection,
            );
          }),
      footerSettings: FooterSettings(
        reservePixels: 30.00,
        scrollMode: IndicatorScrollMode.interact,
        buildChild: (settings, notify, scrollDirection) {
          return DotFooterView(
            scrollDirection: scrollDirection,
            footerNotifier: notify,
            footerSettings: settings,
          );
        },
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
      upDisplay: Container(
        height: 120,
        color: Colors.red.withOpacity(_opacity),
      ),
      persistentHeader: BallisticSliverPersistentHeader(
        pinned: true,
        maxExtent: 40,
        minExtent: 40,
        buildPersistentHeader: (a, b, c, d, e) {
          return Container(
            alignment: Alignment.center,
            color: Colors.blueAccent,
            child: Text('吸顶效果'),
          );
        },
      ),
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
    items.add(
      SizedBox(
        width: 100,
        child: TextField(
          decoration: InputDecoration(
            hintText: '输入',
          ),
        ),
      ),
    );
    for (int i = 0; i < 10; i++) {
      items.add(
        Text('是一行:$i'),
      );
    }
    items.add(
      SizedBox(
        width: 100,
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
