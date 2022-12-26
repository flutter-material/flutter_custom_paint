import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'line_painter.dart';

class show_image extends StatefulWidget {
  show_image({required this.bytesImage});
  final Uint8List bytesImage;

  @override
  State<show_image> createState() => _show_imageState();
}

class _show_imageState extends State<show_image> {
  ui.Image? _image;
  List<ui.Offset> _points = [ui.Offset(90, 120), ui.Offset(320, 120)];
  bool _clear = false;
  int _currentlyDraggedIndex = -1;
  double point_distance = 0.0;

  late double x, y;

  /** 初始化照片 */
  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  Future<void> _asyncInit() async {
    ui.Codec codec = await ui.instantiateImageCodec(widget.bytesImage,
        targetWidth: 720, targetHeight: 1080);
    ui.FrameInfo frame = await codec.getNextFrame();
    setState(() {
      _image = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          children: [
            _image != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center, // vertically,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // horizontally,
                    children: <Widget>[
                      if (_image != null) ...[
                        FittedBox(
                          fit: BoxFit.fill,
                          child: GestureDetector(
                              onPanStart: (DragStartDetails details) {
                                // get distance from points to check if is in circle
                                int indexMatch = -1;
                                for (int i = 0; i < _points.length; i++) {
                                  double distance = sqrt(pow(
                                          details.localPosition.dx -
                                              _points[i].dx,
                                          2) +
                                      pow(
                                          details.localPosition.dy -
                                              _points[i].dy,
                                          2));
                                  if (distance <= 100) {
                                    indexMatch = i;
                                    break;
                                  }
                                }
                                if (indexMatch != -1) {
                                  _currentlyDraggedIndex = indexMatch;
                                }
                              },
                              onPanUpdate: (DragUpdateDetails details) {
                                if (_currentlyDraggedIndex != -1) {
                                  setState(() {
                                    // check point
                                    double x1 = details.localPosition.dx,
                                        y1 = details.localPosition.dy;
                                    if (x1 > 720) {
                                      x1 = 710;
                                    }
                                    if (x1 < 0) {
                                      x1 = 10;
                                    }
                                    if (y1 > 1080) {
                                      y1 = 1070;
                                    }
                                    if (y1 < 0) {
                                      y1 = 10;
                                    }
                                    _points = List.from(_points);
                                    _points[_currentlyDraggedIndex] =
                                        Offset(x1, y1);
                                    // 計算兩點距離
                                    point_distance = sqrt(pow(
                                            _points[0].dx - _points[1].dx, 2) +
                                        pow(_points[0].dy - _points[1].dy, 2));
                                  });
                                }
                              },
                              onPanEnd: (_) {
                                setState(() {
                                  _currentlyDraggedIndex = -1;
                                });
                              },
                              child: SizedBox(
                                width: _image!.width.toDouble(),
                                height: _image!.height.toDouble(),
                                child: CustomPaint(
                                  size: Size(
                                    _image!.width.toDouble(),
                                    _image!.height.toDouble(),
                                  ),
                                  painter: LinePainter(
                                      points: _points,
                                      distance: point_distance,
                                      clear: _clear,
                                      image: _image!),
                                ),
                              )),
                        )
                      ]
                    ],
                  )
                : Container(
                    // child: Expanded(
                    //   child: Image.memory(
                    //     widget.bytesImage,
                    //     fit: BoxFit.cover,
                    //     height: double.infinity,
                    //     width: double.infinity,
                    //   ),
                    // ),
                    ),
          ],
        ),
      ),
    );
  }
}
