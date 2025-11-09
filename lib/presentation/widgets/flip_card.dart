import 'dart:math';

import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.showFront,
    required this.front,
    required this.back,
  });

  final bool showFront;
  final Widget front;
  final Widget back;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotateAnim,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(showFront) != child!.key);
            var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
            tilt *= isUnder ? -1.0 : 1.0;
            final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
            return Transform(
              transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      layoutBuilder: (topChild, _) => Stack(children: [if (topChild != null) topChild]),
      child: showFront
          ? Container(key: const ValueKey(true), child: front)
          : Container(key: const ValueKey(false), child: back),
    );
  }
}
