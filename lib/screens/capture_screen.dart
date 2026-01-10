import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // カメラで撮影
  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
      // TODO: 次の画面（顔を描く画面）へ遷移
    }
  }

  // ギャラリーから選択
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      // TODO: 次の画面（顔を描く画面）へ遷移
    }
  }

  @override
  void initState() {
    super.initState();
    // 画面表示と同時にカメラを起動
    Future.delayed(Duration.zero, () {
      _takePicture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F3F0),
              Color(0xFFE8E3DF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // タイトル
              const Text(
                '石を撮影しましょう',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6D5D52),
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 60),

              // 撮影ガイド
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 円形のガイド
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFBCAAA4),
                            width: 3,
                            style: BorderStyle.solid,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: _imageFile != null
                            ? ClipOval(
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle_outlined,
                                      size: 100,
                                      color: const Color(0xFFBCAAA4).withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      '石をここに',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color(0xFF9E8B7E).withOpacity(0.7),
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),

                      const SizedBox(height: 40),

                      // アドバイステキスト
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '石を円の中央に配置してください',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6D5D52),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ボタンエリア
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  children: [
                    // カメラボタン
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _takePicture,
                        icon: const Icon(Icons.camera_alt, size: 24),
                        label: const Text(
                          'カメラで撮影',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBCAAA4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ギャラリーボタン
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickFromGallery,
                        icon: const Icon(Icons.photo_library, size: 24),
                        label: const Text(
                          'カメラロールから選択',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF9E8B7E),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFFBCAAA4),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}