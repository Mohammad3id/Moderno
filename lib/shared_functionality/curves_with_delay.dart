import 'package:flutter/animation.dart';

class CurveWithDelay extends Curve {
  final Curve curve;
  final double delayRatio;

  const CurveWithDelay({
    required this.curve,
    required this.delayRatio,
  });

  @override
  double transformInternal(double t) {
    if (t < delayRatio) {
      return 0;
    }
    return curve.transformInternal((t - delayRatio) / (1 - delayRatio));
  }
}
