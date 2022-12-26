import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LinePainter extends CustomPainter {
  List<Offset> points;
  double distance;
  bool clear;
  final ui.Image image;

  LinePainter(
      {required this.points,
      required this.distance,
      required this.clear,
      required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final outputRect =
        Rect.fromPoints(ui.Offset.zero, ui.Offset(size.width, size.height));
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes =
        applyBoxFit(BoxFit.contain, imageSize, outputRect.size);
    final Rect inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.center.inscribe(sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
    if (!clear) {
      final circlePaint = Paint()
        ..color = Colors.red
        ..strokeCap = StrokeCap.square
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.multiply
        ..strokeWidth = 2;

      for (int i = 0; i < points.length; i++) {
        // print(points[i].toString() + " " + points[i + 1].toString());
        if (i + 1 == points.length) {
          // canvas.drawLine(points[i], points[0], paint);
        } else {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
        canvas.drawCircle(points[i], 15, circlePaint);
      }
    }
    TextSpan span = TextSpan(
        style: const TextStyle(color: Color(0xFF4E3629), fontSize: 30),
        text: distance.toStringAsFixed(1).toString());
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(5.0, 5.0));
  }

  @override
  bool shouldRepaint(LinePainter oldPainter) =>
      oldPainter.points != points || clear;
}
