import 'package:flutter/widgets.dart';

class SmoothLayout extends StatelessWidget {
  SmoothLayout({super.key, required this.child, this.scrollDirection});

  Widget child;
  Axis? scrollDirection;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Axis _scrollDirection = scrollDirection ?? Axis.horizontal;
        dynamic _constraints;
        if (_scrollDirection == Axis.horizontal) {
          _constraints = BoxConstraints(
            minWidth: constraints.maxWidth,
          );
        }
        if (_scrollDirection == Axis.vertical) {
          _constraints = BoxConstraints(
            minHeight: constraints.maxHeight,
          );
        }
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: _scrollDirection,
          padding: const EdgeInsets.all(0),
          child: ConstrainedBox(
            constraints: _constraints,
            child: child,
          ),
        );
      },
    );
  }
}

class SmoothLayoutBuilder extends LayoutBuilder {
  final Widget Function(BoxConstraints constraints) buildChild;

  SmoothLayoutBuilder({required this.buildChild, Axis? scrollDirection})
      : super(builder: (context, constraints) {
          Axis _scrollDirection = scrollDirection ?? Axis.horizontal;
          dynamic _constraints;
          if (_scrollDirection == Axis.horizontal) {
            _constraints = BoxConstraints(
              minWidth: constraints.maxWidth,
            );
          }
          if (_scrollDirection == Axis.vertical) {
            _constraints = BoxConstraints(
              minHeight: constraints.maxHeight,
            );
          }
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: _scrollDirection,
            padding: const EdgeInsets.all(0),
            child: ConstrainedBox(
              constraints: _constraints,
              child: buildChild(constraints),
            ),
          );
        });
}
