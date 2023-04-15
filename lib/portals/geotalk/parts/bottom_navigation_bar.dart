import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSelectBottomNavigationBarItem = Function(int index);

class GeoBottomNavigationBar extends StatefulWidget {
  const GeoBottomNavigationBar({
    Key? key,
    required this.items,
    this.selectBottomNavigationBarItem,
  }) : super(key: key);
  final List<GeoBottomNavigationBarItem> items;
  final OnSelectBottomNavigationBarItem? selectBottomNavigationBarItem;

  @override
  State<GeoBottomNavigationBar> createState() => _GeoBottomNavigationBarState();
}

class _GeoBottomNavigationBarState extends State<GeoBottomNavigationBar> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFececec),
            width: 1,
          ),
        ),
        color: Color(0x44F2F1F6),
      ),
      height: 50,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _rendItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _rendItems() {
    var items = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      var item = widget.items[i];
      var color = 0xFF333333;
      if (i == _selected) {
        color = 0xFF1684FC;
      }
      items.add(
        InkWell(
          splashColor: const Color(0xFFF2F1F6),
          hoverColor: const Color(0xFFF2F1F6),
          overlayColor: MaterialStateProperty.all(const Color(0xFFF2F1F6)),
          onTap: () {
            if(mounted) {
              setState(() {
                _selected = i;
                if (widget.selectBottomNavigationBarItem != null) {
                  widget.selectBottomNavigationBarItem!(i);
                }
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: Color(color),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(color),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }
}

class GeoBottomNavigationBarItem {
  IconData icon;
  String label;

  GeoBottomNavigationBarItem({required this.icon, required this.label});
}
