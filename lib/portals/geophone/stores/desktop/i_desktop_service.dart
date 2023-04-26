import 'package:geochat_app/portals/geophone/stores/desktop/ol/desktop_ol.dart';

mixin IDesktopService {
  Future<List<DeskFolderOL>> listRootFolder();

  Future<List<DeskFolderOL>> listChildFolder(String folder);

  Future<List<DeskLetOL>> listLet(String folder);

  Future<List<DeskAppOL>> listApp(String folder);

  List<DeskItemOL> sortedList(
      {required List<DeskFolderOL> deskFolders,
      required List<DeskLetOL> deskLets,
      required List<DeskAppOL> deskApps}) ;
}
