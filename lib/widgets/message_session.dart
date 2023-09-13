class MessageSession {
  String faceSrc;
  String title;
  DateTime time;
  String text;
  bool isMute;

  MessageSession({
    required this.faceSrc,
    required this.title,
    required this.time,
    required this.text,
    required this.isMute,
  });
}
