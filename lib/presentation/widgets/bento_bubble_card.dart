import 'package:flutter/material.dart';

class BentoBubbleCard extends StatelessWidget {
  const BentoBubbleCard({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: _TicketClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 12),
                blurRadius: 30,
              ),
            ],
          ),
          padding: padding,
          child: CustomPaint(
            painter: _BubblePainter(),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const notchRadius = 18.0;
    final path = Path()
      ..moveTo(0, notchRadius)
      ..quadraticBezierTo(0, 0, notchRadius, 0)
      ..lineTo(size.width - notchRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, notchRadius)
      ..lineTo(size.width, size.height / 2 - notchRadius)
      ..conicTo(size.width - notchRadius, size.height / 2, size.width, size.height / 2 + notchRadius, 0.7)
      ..lineTo(size.width, size.height - notchRadius)
      ..quadraticBezierTo(size.width, size.height, size.width - notchRadius, size.height)
      ..lineTo(notchRadius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - notchRadius)
      ..lineTo(0, size.height / 2 + notchRadius)
      ..conicTo(notchRadius, size.height / 2, 0, size.height / 2 - notchRadius, 0.7)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.18), Colors.white.withOpacity(0.04)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    final bubblePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.05, size.width * 0.35, size.height * 0.3),
        const Radius.circular(40),
      ));
    canvas.drawPath(bubblePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
