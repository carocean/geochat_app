import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geochat_app/portals/geophone/stores/desktop/ol/desktop_ol.dart';

import '../i_desktop_service.dart';

class DesktopService implements IDesktopService {
  @override
  Future<List<DeskAppOL>> listApp(String folder) async {
    var json = await rootBundle
        .loadString('lib/portals/geophone/stores/mock/desktop-apps.json');
    var items = jsonDecode(json);
    List<DeskAppOL> apps = [];
    for (var item in items) {
      if (item['folder'] != folder) {
        continue;
      }
      apps.add(DeskAppOL.from(item));
    }
    return apps;
  }

  @override
  Future<List<DeskFolderOL>> listChildFolder(String folder) async {
    var json = await rootBundle
        .loadString('lib/portals/geophone/stores/mock/desktop-folders.json');
    var items = jsonDecode(json);
    List<DeskFolderOL> folders = [];
    for (var item in items) {
      if (item['pid'] != folder) {
        continue;
      }
      folders.add(DeskFolderOL.from(item));
    }
    return folders;
  }

  @override
  Future<List<DeskLetOL>> listLet(String folder) {
    // TODO: implement listLet
    throw UnimplementedError();
  }

  @override
  Future<List<DeskFolderOL>> listRootFolder() async {
    var json = await rootBundle
        .loadString('lib/portals/geophone/stores/mock/desktop-folders.json');
    var items = jsonDecode(json);
    List<DeskFolderOL> folders = [];
    for (var item in items) {
      folders.add(DeskFolderOL.from(item));
    }
    return folders;
  }

  @override
  List<DeskItemOL> sortedList(
      {required List<DeskFolderOL> deskFolders,
      required List<DeskLetOL> deskLets,
      required List<DeskAppOL> deskApps}) {
    List<DeskItemOL> fullList = <DeskItemOL>[
      ...deskFolders,
      ...deskLets,
      ...deskApps
    ];
    fullList.sort((a, b) {
      return a.order.compareTo(b.order);
    });

    return fullList;
  }
}
