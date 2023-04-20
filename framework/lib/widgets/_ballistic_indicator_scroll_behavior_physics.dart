import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '_ballistic_indicator_ultimate.dart';

typedef CreateScrollBehavior = ScrollBehavior Function(
    IndicatorSettings settings);

class IndicatorScrollBehavior extends ScrollBehavior {
  final ScrollPhysics? _physics;

  const IndicatorScrollBehavior([this._physics]);

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return _physics ?? super.getScrollPhysics(context);
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.unknown,
      };
}

class IndicatorScrollPhysics extends ScrollPhysics {
  final HeaderNotifier headerNotifier;
  final FooterNotifier footerNotifier;
  final ValueNotifier<bool> userOffsetNotifier;

  /// Used to determine parameters for friction simulations.
  final ScrollDecelerationRate decelerationRate;

  IndicatorScrollPhysics({
    ScrollPhysics? parent = const AlwaysScrollableScrollPhysics(),
    this.decelerationRate = ScrollDecelerationRate.normal,
    required this.headerNotifier,
    required this.footerNotifier,
    required this.userOffsetNotifier,
  }) : super(parent: parent);

  double frictionFactor(double overscrollFraction) {
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        return 0.07 * math.pow(1 - overscrollFraction, 2);
      case ScrollDecelerationRate.normal:
        return 0.52 * math.pow(1 - overscrollFraction, 2);
    }
  }

  @override
  IndicatorScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return IndicatorScrollPhysics(
      parent: buildParent(ancestor),
      headerNotifier: headerNotifier,
      footerNotifier: footerNotifier,
      userOffsetNotifier: userOffsetNotifier,
      decelerationRate: decelerationRate,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    userOffsetNotifier.value = true;
    if (!position.outOfRange) {
      return offset;
    }

    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) {
        return absDelta * gamma;
      }
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (userOffsetNotifier.value &&
        (headerNotifier.isForbidScroll ||
            position.pixels < -headerNotifier.reservePixels)) {
      if (value < position.pixels &&
          position.pixels <= position.minScrollExtent) {
        // Underscroll.
        headerNotifier.updatePosition(position, ScrollState.underScrolling);
        return value - position.pixels;
      }
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // Hit top edge. 就是下滑的时候手指已经离开凭惯性在下滑的过程中顶部到达的边界
      headerNotifier.updatePosition(position, ScrollState.hitTopEdge);
      return value - position.minScrollExtent;
    }
    // print(
    //     '::::pixels=${position.pixels}::minScrollExtent=${position.minScrollExtent}::maxScrollExtent=${position.maxScrollExtent}');
    if (userOffsetNotifier.value &&
        (footerNotifier.isForbidScroll ||
            position.pixels >
                position.maxScrollExtent + footerNotifier.reservePixels)) {
      if (position.maxScrollExtent <= position.pixels &&
          position.pixels < value) {
        // Overscroll.
        footerNotifier.updatePosition(position, ScrollState.overScrolling);
        return value - position.pixels;
      }
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge. 就是上滑的时候手指已经离开凭惯性在下滑的过程中低部到达的边界
      footerNotifier.updatePosition(position, ScrollState.hitBottomEdge);
      return value - position.maxScrollExtent;
    }
    headerNotifier.updatePosition(position, ScrollState.sliding);
    footerNotifier.updatePosition(position, ScrollState.sliding);
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // print(
    //     '::velocity=${velocity}::pixels=${position.pixels}::minScrollExtent=${position.minScrollExtent}::maxScrollExtent=${position.maxScrollExtent}');
    userOffsetNotifier.value = false;
    // 返回null则没有回弹动画，也没有内容区的惯性滚动
    if (position.pixels == -headerNotifier.reservePixels) {
      headerNotifier.updatePosition(position, ScrollState.underScrollEnd);
      return null;
    }
    if (position.pixels ==
        position.maxScrollExtent + footerNotifier.reservePixels) {
      footerNotifier.updatePosition(position, ScrollState.overScrollEnd);
      return null;
    }
    final Tolerance tolerance = this.tolerance;
    if (!position.outOfRange) {
      if (velocity.abs() < tolerance.velocity) {
        return null;
      }
      if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
        return null;
      }
      if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
        return null;
      }
      return ClampingScrollSimulation(
        position: position.pixels,
        velocity: velocity,
        tolerance: tolerance,
      );
    }

    double constantDeceleration;
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        constantDeceleration = 1400;
        break;
      case ScrollDecelerationRate.normal:
        constantDeceleration = 0;
        break;
    }

    if (position.pixels < -headerNotifier.reservePixels) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity,
        leadingExtent: -headerNotifier.reservePixels,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
        constantDeceleration: constantDeceleration,
      );
    }

    if (position.pixels >
        position.maxScrollExtent + footerNotifier.reservePixels) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent + footerNotifier.reservePixels,
        tolerance: tolerance,
        constantDeceleration: constantDeceleration,
      );
    }

    return BouncingScrollSimulation(
      spring: spring,
      position: position.pixels,
      velocity: velocity,
      leadingExtent: position.minScrollExtent,
      trailingExtent: position.maxScrollExtent,
      tolerance: tolerance,
      constantDeceleration: constantDeceleration,
    );
  }

  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  double get maxFlingVelocity {
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        return kMaxFlingVelocity * 8.0;
      case ScrollDecelerationRate.normal:
        return super.maxFlingVelocity;
    }
  }

  @override
  SpringDescription get spring {
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        return SpringDescription.withDampingRatio(
          mass: 0.3,
          stiffness: 75.0,
          ratio: 1.3,
        );
      case ScrollDecelerationRate.normal:
        return super.spring;
    }
  }
}
