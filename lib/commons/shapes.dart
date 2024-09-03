import 'package:flutter/material.dart';

class Shapes extends StatefulWidget {
  const Shapes({super.key});

  @override
  State<Shapes> createState() => _ShapesState();
}

class _ShapesState extends State<Shapes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 700,
            width: double.infinity,
            color: Colors.red,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 600),
                  painter: RPSCustomPainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint configuration for filling
    Paint paintFill = Paint()
      ..color = const Color.fromARGB(255, 70, 68, 68)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0
      ..strokeCap = StrokeCap.round // Smooth edges
      ..strokeJoin = StrokeJoin.round; // Smooth corners

    // Define the path
    Path path = Path();
    path.moveTo(size.width * -0.0072000, size.height * -0.0006667);
    path.lineTo(size.width * 0.9980000, size.height * 0.0033333);
    path.lineTo(size.width * 1.0040000, size.height * 1.0033333);
    path.quadraticBezierTo(size.width * 0.7809000, size.height * 0.4473333,
        size.width * 0.6260000, size.height * 0.3846667);
    path.cubicTo(
        size.width * 0.2802000,
        size.height * 0.3430000,
        size.width * 0.2442000,
        size.height * 0.2816667,
        size.width * 0.1484000,
        size.height * 0.1860000);
    path.quadraticBezierTo(size.width * 0.1131000, size.height * 0.1346667,
        size.width * -0.0072000, size.height * -0.0006667);
    path.close();

    // Draw the path with fill
    canvas.drawPath(path, paintFill);

    // Optionally, draw a border or outline if needed
    Paint paintStroke = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243) // No visible stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 // Adjust as needed
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
