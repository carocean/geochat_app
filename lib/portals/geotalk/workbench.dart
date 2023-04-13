import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:geochat_app/portals/geotalk/parts/bottom_navigation_bar.dart';

class GeotalkWorkBench extends StatefulWidget {
  final PageContext context;

  const GeotalkWorkBench({Key? key, required this.context}) : super(key: key);

  @override
  State<GeotalkWorkBench> createState() => _GeotalkWorkBenchState();
}

class _GeotalkWorkBenchState extends State<GeotalkWorkBench> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: GeoBottomNavigationBar(
        selectBottomNavigationBarItem: (index) {
          print(index);
        },
        items: [
          GeoBottomNavigationBarItem(
            icon: IconData(
              0xe62d,
              fontFamily: 'bottomNavigationBar',
            ),
            label: '地微',
          ),
          GeoBottomNavigationBarItem(
            icon: IconData(
              0xe655,
              fontFamily: 'bottomNavigationBar',
            ),
            label: '通讯录',
          ),
          GeoBottomNavigationBarItem(
            icon: IconData(
              0xe605,
              fontFamily: 'bottomNavigationBar',
            ),
            label: '发现',
          ),
          GeoBottomNavigationBarItem(
            icon: IconData(
              0xe8a0,
              fontFamily: 'bottomNavigationBar',
            ),
            label: '我',
          ),
        ],
      ),
    );
  }
}
