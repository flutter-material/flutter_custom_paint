import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'line_painter.dart';
import 'pick_image.dart';
import 'home_page.dart';

class MeasureObject extends StatefulWidget {
  const MeasureObject(
      {super.key,
      required this.bytesImage,
      required this.imageWidth,
      required this.imageHeight});
  final Uint8List bytesImage;
  final int imageWidth;
  final int imageHeight;
  @override
  State<MeasureObject> createState() => _MeasureObjectState();
}

class _MeasureObjectState extends State<MeasureObject> {
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
    // 讀取拍攝影像
    ui.Codec codec = await ui.instantiateImageCodec(widget.bytesImage,
        targetWidth: widget.imageWidth, targetHeight: widget.imageHeight);
    ui.FrameInfo frame = await codec.getNextFrame();

    setState(() {
      // 取得拍攝影像
      _image = frame.image;
      // 調整初始兩點座標
      double x1 = widget.imageWidth / 6;
      double x2 = widget.imageWidth / 6 + widget.imageWidth / 3;
      double y1 = widget.imageHeight / 6;
      double y2 = widget.imageHeight / 6;
      _points = [ui.Offset(x1, y1), ui.Offset(x2, y2)];
      // 初始化兩點距離
      point_distance = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          _image != null
              ? Expanded(
                  child: Column(
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
                                    if (x1 > widget.imageWidth) {
                                      x1 = widget.imageWidth - 10;
                                    }
                                    if (x1 < 0) {
                                      x1 = 10;
                                    }
                                    if (y1 > widget.imageHeight) {
                                      y1 = widget.imageHeight - 10;
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
                      ],
                    ],
                  ),
                )
              : Container(
                  child: Expanded(
                    child: Image.memory(
                      widget.bytesImage,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.black12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PickImage()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.reply_all,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                // print('button tapped');
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
