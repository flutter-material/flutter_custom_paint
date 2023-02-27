# flutter_custom_paint

<img src="./screenshot/demo.gif" width=250>



## Reference
inspired by
- [thealiflab/ImageShapeApp](https://github.com/thealiflab/ImageShapeApp/blob/master/lib/rectangle_painter.dart)
- [arconsis/measurements](https://github.com/arconsis/measurements/issues)
- [Drawing rectangle between two points with arbitrary width](https://stackoverflow.com/questions/7854043/drawing-rectangle-between-two-points-with-arbitrary-width)
- [Determine a bounding rectangle around a diagonal line](https://stackoverflow.com/questions/38807203/determine-a-bounding-rectangle-around-a-diagonal-line)
- [How to add line dash in Flutter](https://stackoverflow.com/a/67653238)
- [How to Draw a Triangle using Canvas in Flutter?](https://fluttercentral.com/Articles/Post/1154/How_to_Draw_a_Triangle_using_Canvas_in_Flutter)
- [Getting the third point from two points on one line](https://math.stackexchange.com/questions/22689/getting-the-third-point-from-two-points-on-one-line)

- [ruler](https://juejin.cn/post/7022914592779010055)



Canvas canvasRuler = Canvas(bitmap);
Path rulerFrame = Path();
double YC = (((points[0].dy + points[1].dy) - lAB) / 2.0);
double XC = (((points[0].dx + points[1].dx) - 30) / 2.0);
rulerFrame.moveTo(XC, YC);
rulerFrame.lineTo(XC + 30, YC);
rulerFrame.lineTo(XC + 30, YC + lAB);
rulerFrame.lineTo(XC, YC + lAB);
rulerFrame.close();
canvas.translate((points[0].dx + points[1].dx) / 2.0,
(points[0].dy + points[1].dy) / 2.0);
canvas.rotate(-(degree + 180));
canvas.drawPath(rulerFrame, mPaintRulerBackground);