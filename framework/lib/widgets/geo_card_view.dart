import 'package:flutter/material.dart';
import 'package:framework/core_lib/_ultimate.dart';

class BlankCardView extends StatelessWidget {
  BlankCardView({Key? key, required this.child,this.padding,this.margin}) : super(key: key);
  Widget child;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:margin?? const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      padding: padding,
      constraints: const BoxConstraints.tightFor(width: double.infinity),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFefefef),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class SimpleCardView extends StatelessWidget {
  ValueNotifier<List<SimpleCardViewItem>> _items;
  EdgeInsetsGeometry? padding;
  SimpleCardView({Key? key, required List<SimpleCardViewItem> items,this.padding})
      : _items = ValueNotifier(items),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _items,
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const SizedBox.shrink();
        }
        var items = <Widget>[];
        for (var i = 0; i < value.length; i++) {
          var row = value[i];
          items.add(_rendRow(row));
          if (i < value.length - 1) {
            items.add(
              const Divider(
                height: 1,
                indent: 50,
              ),
            );
          }
        }
        return BlankCardView(
          padding: padding,
          child: Column(
            children: items,
          ),
        );
      },
    );
  }

  Widget _rendRow(SimpleCardViewItem e) {
    return InkWell(
      onTap: e.onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 10,
          right: 10,
        ),
        child: Row(
          children: [
            e.icon,
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Row(
                children: _renderRowContent(e),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFFc3c3c4),
            ),
          ],
        ),
      ),
    );
  }

  _renderRowContent(SimpleCardViewItem e) {
    var items = <Widget>[];

    if (StringUtil.isEmpty(e.tips)) {
      items.add(
        Expanded(
          child: Text(
            e.title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      items.add(
        Text(e.title),
      );
      items.add(
        const SizedBox(
          width: 10,
        ),
      );
      items.add(
        Expanded(
          child: Text(
            e.tips!,
          ),
        ),
      );
    }

    return items;
  }
}

class SimpleCardViewItem {
  final Widget icon;
  final String title;
  String? tips;
  Function()? onTap;

  SimpleCardViewItem(
      {required this.icon, required this.title, this.tips, this.onTap});
}
