import 'dart:math';

import 'package:flutter/material.dart';

class Parallax3DImage extends StatefulWidget {
  const Parallax3DImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.borderRadius = 24,
    this.onTap,
    this.height,
    this.enableHero = true,
  });

  final String imageUrl;
  final String heroTag;
  final double borderRadius;
  final VoidCallback? onTap;
  final double? height;
  final bool enableHero;

  @override
  State<Parallax3DImage> createState() => _Parallax3DImageState();
}

class _Parallax3DImageState extends State<Parallax3DImage> {
  double _tiltX = 0;
  double _tiltY = 0;

  void _updateTilt(Offset offset, Size size) {
    final center = size.center(Offset.zero);
    final dx = (offset.dx - center.dx) / size.width;
    final dy = (offset.dy - center.dy) / size.height;
    setState(() {
      _tiltX = dy * -0.3;
      _tiltY = dx * 0.3;
    });
  }

  void _resetTilt() {
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        height: widget.height ?? 180,
        width: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.black12,
          );
        },
      ),
    );

    if (widget.enableHero) {
      image = Hero(tag: widget.heroTag, child: image);
    }

    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (details) => _updateTilt(details.localPosition, context.size ?? Size.zero),
      onPanUpdate: (details) => _updateTilt(details.localPosition, context.size ?? Size.zero),
      onPanEnd: (_) => _resetTilt(),
      onPanCancel: _resetTilt,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateX(_tiltX)
          ..rotateY(_tiltY),
        child: image,
      ),
    );
  }
}
