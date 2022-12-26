import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'show_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: 720,
        // maxHeight: 1080,
        // imageQuality: 90,
      );
      setState(() async {
        // 多張照片選取只拿第一張
        List<XFile>? imageFileList =
            pickedFile == null ? null : <XFile>[pickedFile];
        File imageFile = File(imageFileList![0].path);
        final bytes = await imageFile.readAsBytes();
        Navigator.push(context!, MaterialPageRoute(builder: (context) {
          return show_image(
            bytesImage: bytes,
          );
        }));
      });
    } catch (e) {
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image picker'),
      ),
      body: const Center(
        child: Text('Body Text'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onImageButtonPressed(ImageSource.camera, context: context);
        },
        backgroundColor: Color(0xFF4E3629),
        child: Icon(Icons.add),
      ),
    );
  }
}
