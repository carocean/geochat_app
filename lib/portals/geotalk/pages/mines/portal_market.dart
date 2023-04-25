import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              children: _renderPortals(),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _renderPortals() {
    var items = <Widget>[];
    var data = _notifier.data;
    for (int i = 0; i < data.length; i++) {
      var portal = data[i];
      if (i == _notifier.currentPortal) {
        items.add(_renderCurrentPortal(portal));
        continue;
      }
      items.add(SizedBox(
        height: 30,
      ));
      items.add(
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              '精选',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      items.add(
        SizedBox(
          height: 10,
        ),
      );
      items.add(_renderOtherPortal(portal));
      items.add(
        SizedBox(
          height: 120,
        ),
      );
    }
    return items;
  }

  Widget _renderCurrentPortal(PortalInfo portal) {
    return BlankCardView(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15,
        right: 15,
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://tva1.sinaimg.cn/large/0075TGutgy1gy6a3nrcgbj31za4a7e84.jpg',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://tva1.sinaimg.cn/large/0075TGutgy1gy6a3nrcgbj31za4a7e84.jpg',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://tva1.sinaimg.cn/large/0075TGutgy1gy6a3nrcgbj31za4a7e84.jpg',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ],
          ),
          Column(
            children: [
              Center(
                child: Text(
                  portal.title,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  '当前使用',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              _rendProperty(
                iconData: FontAwesomeIcons.shirt,
                iconColor: Colors.orange,
                title: '背景色',
                tips: '当前：太空灰',
              ),
              Divider(
                height: 1,
                indent: 45,
              ),
              _rendProperty(
                  iconData: FontAwesomeIcons.image,
                  iconColor: Colors.blueGrey,
                  title: '背景图',
                  tips: '用于说说、个人主页等'),
              Divider(
                height: 1,
                indent: 45,
              ),
              _rendProperty(
                iconData: FontAwesomeIcons.font,
                iconColor: Colors.black87,
                title: '字体',
                tips: '字体、字号',
              ),
              Divider(
                height: 1,
                indent: 45,
              ),
              _rendProperty(
                iconData: FontAwesomeIcons.language,
                iconColor: Colors.green,
                title: '语言',
                tips: '简体中文',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderOtherPortal(PortalInfo portal) {
    return BlankCardView(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15,
        right: 15,
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://tva1.sinaimg.cn/large/0075TGutgy1gy6a3nrcgbj31za4a7e84.jpg',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://tva1.sinaimg.cn/large/0075TGutgy1gy6a3nrcgbj31za4a7e84.jpg',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://tva1.sinaimg.cn/large/0075TGutgy1gy6a3nrcgbj31za4a7e84.jpg',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ],
          ),
          Column(
            children: [
              Center(
                child: Text(portal.title),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.lightGreen),
                      alignment: Alignment.center,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_accessibility,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '使用该风格',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _rendProperty(
      {required IconData iconData,
      required String title,
      Color? iconColor,
      String? tips}) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 24,
            color: iconColor,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                tips ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFFc3c3c4),
          ),
        ],
      ),
    );
  }
}

class PortalMarketNotifier extends Notifier {
  PortalMarketNotifier.create() {
    load();
  }

  List<PortalInfo> data = [];
  late int currentPortal = 0;

  Future<void> load() async {
    data.add(PortalInfo(title: '聊天推荐', id: 'geotalk', note: ''));
    data.add(PortalInfo(title: '效率推荐', id: 'geophone', note: ''));
    currentPortal = 0;
    notifyListeners();
  }
}
