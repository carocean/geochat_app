import 'package:flutter/cupertino.dart';

import '_window_task.dart';

class Window extends StatelessWidget {
  Window(
      {Key? key, required this.viewport, required this.windowTask})
      : super(key: key);
  final Widget viewport;
  final WindowTask windowTask;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: windowTask.listenable(),
      builder: (context, value, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            viewport,
          ],
        );
      },
    );
  }
}
