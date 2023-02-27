import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'measure_object.dart';
import 'home_page.dart';

class PickImage extends StatefulWidget {
  const PickImage({Key? key}) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  final ImagePicker _picker = ImagePicker();

  /// 開啟相機拍攝
  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: 720,
        maxHeight: 720,
        // imageQuality: 90,
      );
      setState(() async {
        // 多張照片選取只拿第一張
        List<XFile>? imageFileList =
            pickedFile == null ? null : <XFile>[pickedFile];

        /// 判斷是否有成功取得影像
        if (pickedFile != null) {
          // 取得第一張影像
          File imageFile = File(imageFileList![0].path);
          final bytes = await imageFile.readAsBytes();
          // 取得影像實際大小
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
          final descriptor = await ui.ImageDescriptor.encoded(buffer);
          final imageWidth = descriptor.width;
          final imageHeight = descriptor.height;
          print("imageWidth: $imageWidth, imageHeight: $imageHeight");
          descriptor.dispose();
          buffer.dispose();

          // 畫面跳轉=>MeasureObject()
          Navigator.pushAndRemoveUntil(
              context!,
              MaterialPageRoute(
                builder: (context) => MeasureObject(
                  bytesImage: bytes,
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                ),
              ),
              (route) => false);
        } else {
          // 尚未取得影像故返回主頁
          Navigator.pushAndRemoveUntil(
              context!,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        }
      });
    } catch (e) {
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化自動觸發相機
    _onImageButtonPressed(ImageSource.camera, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
