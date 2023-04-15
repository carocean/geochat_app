import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:geochat_app/common/Inertial_layout.dart';

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
    return InertialSliverLayoutWidget(
      parentContext: context,
      opacityListener: OpacityListener(
          opacityEvent: (opacity) {
            if(mounted) {
              setState(() {
                _opacity = opacity;
              });
            }
          },
          scrollHeight: 96,beginIsOpacity: _opacity==1?false:true),
      upDisplay: Container(
        height: 120,
        color: Colors.red.withOpacity(_opacity),
      ),
      persistentHeader: InertialSliverPersistentHeader(
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
    items.add(TextField(
      decoration: InputDecoration(
        hintText: '输入',
      ),
    ));
    for (int i = 0; i < 60; i++) {
      items.add(
        Text('是一行:$i'),
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
