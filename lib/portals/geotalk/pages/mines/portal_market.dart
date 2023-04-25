import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

import '../../stores/models/portal_info.dart';

class PortalMarketPage extends StatelessWidget {
  PortalMarketPage({Key? key})
      : _notifier = PortalMarketNotifier.create(),
        super(key: key);
  final PortalMarketNotifier _notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _notifier.listenable(),
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '地微风格',
              style: TextStyle(fontSize: 16),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: BallisticSingleChildScrollView(
            display: Column(
              children: _notifier.data.map((e) {
                return Container(
                  child: Text(e.title),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class PortalMarketNotifier extends Notifier {
  PortalMarketNotifier.create() {
    load();
  }

  List<PortalInfo> data = [];

  Future<void> load() async {
    data.add(PortalInfo(title: '聊天推荐', id: 'geotalk', note: ''));
    data.add(PortalInfo(title: '效率推荐', id: 'geophone', note: ''));
    notifyListeners();
  }
}
