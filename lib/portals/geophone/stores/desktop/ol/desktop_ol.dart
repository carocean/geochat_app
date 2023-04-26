class DeskAppOL extends DeskItemOL {
  String src;
  String folder;

  DeskAppOL({
    required String id,
    required String title,
    required int order,
    required this.src,
    required this.folder,
  }) : super(id: id, title: title, order: order);

  static DeskAppOL from(obj) {
    return DeskAppOL(
      id: obj['id'],
      title: obj['title'],
      order: obj['order'],
      src: obj['src'],
      folder: obj['folder'],
    );
  }
}

//桌面小栏目
class DeskLetOL extends DeskItemOL {
  String folder;

  DeskLetOL({
    required String id,
    required String title,
    required int order,
    required this.folder,
  }) : super(id: id, title: title, order: order);
}

///桌面文件夹共分三层：桌面一页一个文件夹，一页之内可有文件夹，文件夹内的分页一页一个文件夹
class DeskFolderOL extends DeskItemOL {
  String pid;

  DeskFolderOL({
    required String id,
    required String title,
    required int order,
    required this.pid,
  }) : super(id: id, title: title, order: order);

  static DeskFolderOL from(obj) {
    return DeskFolderOL(
      id: obj['id'],
      order: obj['order'],
      title: obj['title'],
      pid: obj['pid'],
    );
  }
}

abstract class DeskItemOL {
  String id;
  String title;
  int order;

  DeskItemOL({required this.id, required this.title, required this.order});
}
