import 'package:flutter/material.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:geochat_app/portals/geotalk/parts/bottom_navigation_bar.dart';
import 'package:geochat_app/portals/geotalk/parts/geotalk_part_view.dart';

class GeotalkWorkBench extends StatefulWidget {
  final PageContext context;

  const GeotalkWorkBench({Key? key, required this.context}) : super(key: key);

  @override
  State<GeotalkWorkBench> createState() => _GeotalkWorkBenchState();
}

class _GeotalkWorkBenchState extends State<GeotalkWorkBench> {
  late GeotalkPartViewDelegate _partViewDelegate;

  @override
  void initState() {
    _partViewDelegate = GeotalkPartViewDelegate(
        pageController: PageController(initialPage: 0, keepPage: false));
    super.initState();
  }

  @override
  void dispose() {
    _partViewDelegate.dispose();
    super.dispose();
  }

  List<GeotalkPartView> buildPartViews(BuildContext context) {
    return [
      GeotalkPartView(
        appBar: AppBar(
          title: const Text(
            '地微',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_circle_outline_sharp,
                size: 24,
              ),
            ),
          ],
        ),
        bottom: GeoBottomNavigationBarItem(
          icon: const IconData(
            0xe62d,
            fontFamily: 'bottomNavigationBar',
          ),
          label: '地微',
        ),
        display: widget.context.part('/messages', context)!,
      ),
      GeotalkPartView(
        appBar: AppBar(
          title: const Text(
            '通讯录',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        bottom: GeoBottomNavigationBarItem(
          icon: const IconData(
            0xe655,
            fontFamily: 'bottomNavigationBar',
          ),
          label: '通讯录',
        ),
        display: widget.context.part('/contacts', context)!,
      ),
      GeotalkPartView(
        appBar: AppBar(
          title: const Text(
            '发现',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        bottom: GeoBottomNavigationBarItem(
          icon: const IconData(
            0xe605,
            fontFamily: 'bottomNavigationBar',
          ),
          label: '发现',
        ),
        display: widget.context.part('/discoveries', context)!,
      ),
      GeotalkPartView(
        bottom: GeoBottomNavigationBarItem(
          icon: const IconData(
            0xe8a0,
            fontFamily: 'bottomNavigationBar',
          ),
          label: '我',
        ),
        display: widget.context.part('/mines', context)!,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _partViewDelegate.build(context: context, buildPartViews: buildPartViews);
    var appBar = _partViewDelegate.current.appBar;
    return Scaffold(
      appBar: appBar,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(), //禁止页面左右滑动切换
          controller: _partViewDelegate.pageController,
          children: _partViewDelegate.displays,
        ),
      ),
      bottomNavigationBar: GeoBottomNavigationBar(
        selectBottomNavigationBarItem: (index) {
          if (mounted) {
            setState(() {
              _partViewDelegate.jumpToPartView(index);
            });
          }
        },
        items: _partViewDelegate.bottoms,
      ),
    );
  }
}
