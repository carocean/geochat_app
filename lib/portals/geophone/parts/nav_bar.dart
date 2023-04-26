import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class NavBar extends StatelessWidget {
  NavBar({Key? key, required PageController controller, required int count})
      : _navBarNotifier =
            NavBarNotifier(pageController: controller, count: count),
        super(key: key);
  NavBarNotifier _navBarNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _navBarNotifier.listenable(),
        builder: (context, value, child) {
          value as NavBarNotifier;
          var dots = <Widget>[];
          if (value.showButtom) {
            dots.add(_renderButtom(context));
          } else {
            for (var i = 0; i < value.count; i++) {
              if (i == value.index) {
                dots.add(_renderDot(true));
                continue;
              }
              dots.add(_renderDot(false));
            }
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.only(
              left: 6,
              right: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots,
            ),
          );
        });
  }

  Widget _renderDot(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 8,
        bottom: 8,
      ),
      child: SizedBox(
        width: 6,
        height: 6,
        child: CircleAvatar(
          backgroundColor: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _renderButtom(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('这是搜索'),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: 5,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_sharp,
              size: 12,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '搜索',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarNotifier extends Notifier {
  PageController pageController;
  int count;
  int index = 0;
  Timer? timer;
  bool showButtom = true;

  NavBarNotifier({required this.pageController, required this.count}) {
    pageController.addListener(() {
      showButtom = false;
      var page = pageController.page ?? 0.0;
      index = page.round();
      notifyListeners();
      _recheck();
    });
  }

  _recheck() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      showButtom = true;
      notifyListeners();
    });
  }
}
