import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

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
        canvas.drawCircle(points[i], 10, circlePaint);
      }
    }

    // 線條數字
    var difference = points[0] - points[1]; // end - start
    var _position = points[1] + difference / 2.0;
    double _radians = difference.direction;

    if (_radians.abs() >= pi / 2.0) {
      _radians += pi;
    }

    canvas.translate(_position.dx, _position.dy);
    canvas.rotate(_radians);
    TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.red, fontSize: 25),
        text: "${distance.toStringAsFixed(1)} cm");
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(-50.0, 10.0));
  }

  @override
  bool shouldRepaint(LinePainter oldPainter) =>
      oldPainter.points != points || clear;
}
