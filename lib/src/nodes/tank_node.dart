import 'dart:math' as math;
import 'package:diagram/src/node.dart';
import 'package:flutter/material.dart';

class TankNode extends DiagramNode {
  @override
  Widget build(
      {required BuildContext context,
      required double scale,
      required double viewportWidth,
      required double viewportHeight}) {
    return _TankWidget(node: this);
  }
}

class _TankWidget extends StatefulWidget {
  const _TankWidget({required this.node});

  final TankNode node;

  @override
  State<StatefulWidget> createState() => _TankWidgetState();
}

class _TankWidgetState extends State<_TankWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(50, 200),
          painter: WaveCustomPainter(_animation.value),
          //painter: WaveCustomPainter2(),
        );
      },
    );
  }
}

class WaveCustomPainter extends CustomPainter {
  final double animationValue;

  WaveCustomPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path = Path();
    path.moveTo(0, size.height / 2);

    double waveAmplitude = size.height / 10;
    double waveWidth = size.width / 2;

    double x = (animationValue * 2 * math.pi);

    path.relativeQuadraticBezierTo(
        waveWidth / 2, -waveAmplitude * math.sin(x), waveWidth, 0);
    path.relativeQuadraticBezierTo(
        waveWidth / 2, waveAmplitude * math.sin(x), waveWidth, 0);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
