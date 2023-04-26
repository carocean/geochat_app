import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:geochat_app/portals/geophone/stores/desktop/ol/desktop_ol.dart';

import '../stores/desktop/i_desktop_service.dart';
import '../stores/desktop/services/desktop_service.dart';

class DesktopPage extends StatelessWidget {
  DesktopPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DesktopNotifier desktopNotifier =
        Pageis.of(context)!.$.partArgs['desktopNotifier'];
    return ValueListenableBuilder(
        valueListenable: desktopNotifier.listenable(),
        builder: (context, value, child) {
          value as DesktopNotifier;
          return SizedBox.expand(
            child: LayoutBuilder(
              builder: (context, constraints) {
                //计算能放的行数，如果溢出，其它的排到下一页，如果没有下一页则新建
                //计算app区域的宽度，再除以childAspectRatio得到app区域高度
                //可通过flutter inspector来看到容量
                double paddingTop=80.00, paddingLeft=20.00,paddingRight=20.00,crossAxisSpacing=20.00,childAspectRatio=0.91,mainAxisSpacing=30.00;
                double appRegionHeight=((constraints.maxWidth-paddingRight-paddingLeft)/4-15)/childAspectRatio;
                double rowCount=(constraints.maxHeight-paddingTop)/(appRegionHeight+20);
                int capacity=4*rowCount.floor();//能容纳app区域的容量，但是如果桌面有desklet怎么办？
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 80,
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.all(0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.91,
                      crossAxisSpacing: 20,
                      // mainAxisExtent:
                    ),
                    itemBuilder: (context, index) {
                      if (index >= value.apps.length) {
                        return const SizedBox.shrink();
                      }
                      var app = value.apps[index];
                      return _renderApp(app);
                    },
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                );
              },
            ),
          );
        });
  }

  Widget _renderApp(DeskAppOL app) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              // image: DecorationImage(
              //   image: AssetImage('lib/portals/geotalk/images/examples/cat.jpeg'),
              //   fit: BoxFit.contain,
              // ),
            ),
            width: 55,
            height: 55,
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 70,
            child: Center(
              child: Text(
                app.title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopNotifier extends Notifier {
  DeskFolderOL folder;
  List<DeskAppOL> apps = [];

  DesktopNotifier({required this.folder}) {
    _load();
  }

  Future<void> _load() async {
    IDesktopService desktopService = DesktopService();
    apps = await desktopService.listApp(folder.id);
    apps = desktopService.sortedList(
        deskFolders: [], deskLets: [], deskApps: apps).cast<DeskAppOL>();
    notifyListeners();
  }
}
