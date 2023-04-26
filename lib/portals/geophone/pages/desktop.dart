import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:geochat_app/portals/geophone/stores/desktop/ol/desktop_ol.dart';

import '../stores/desktop/i_desktop_service.dart';
import '../stores/desktop/services/desktop_service.dart';

class DesktopPage extends StatelessWidget {
  DesktopPage({
    Key? key,
  })  :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DesktopNotifier desktopNotifier = Pageis.of(context)!.$.partArgs['desktopNotifier'];
    return ValueListenableBuilder(
        valueListenable: desktopNotifier.listenable(),
        builder: (context, value, child) {
          value as DesktopNotifier;
          var apps = value.apps;
          var items = <Widget>[];
          for (var app in apps) {
            items.add(_renderApp(app));
          }
          return SizedBox.expand(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      minWidth: constraints.maxWidth,
                      maxWidth: constraints.maxWidth,
                      maxHeight: constraints.maxHeight,
                    ),
                    margin: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 80,
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 30,
                      alignment: WrapAlignment.spaceBetween,
                      children: items,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  Widget _renderApp(DeskAppOL app) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 55,
          height: 55,
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 70,
          child: Center(
            child: Text(
              app.title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
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
