import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/remove_bg_service.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  File? _imageFile;
  File? _processedImageFile; // 背景除去後の画像
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false; // 処理中フラグ

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
      await _processImage(File(photo.path));
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
      await _processImage(File(image.path));
    }
  }

  // 背景除去処理
  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // 背景除去サービスを呼び出す
      final processedFile = await RemoveBgService.removeBackground(imageFile);
      
      setState(() {
        _processedImageFile = processedFile ?? imageFile;
        _isProcessing = false;
      });

      // 成功時のメッセージ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              processedFile != null ? '背景除去が完了しました！' : '背景除去に失敗しました',
            ),
            backgroundColor: processedFile != null 
                ? const Color(0xFF9E8B7E) 
                : Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // TODO: 成功したら次の画面（顔を描く画面）へ自動遷移
      // if (processedFile != null) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DrawFaceScreen(imageFile: processedFile),
      //     ),
      //   );
      // }

    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipOval(
                                    child: Image.file(
                                      _processedImageFile ?? _imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // 処理中のオーバーレイ
                                  if (_isProcessing)
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '背景を除去中...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
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
                        child: Text(
                          _isProcessing 
                              ? '少々お待ちください...'
                              : '石を円の中央に配置してください',
                          style: const TextStyle(
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
                        onPressed: _isProcessing ? null : _takePicture,
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
                          disabledBackgroundColor: const Color(0xFFD4CFC8),
                          disabledForegroundColor: Colors.white70,
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
                        onPressed: _isProcessing ? null : _pickFromGallery,
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
                          disabledForegroundColor: const Color(0xFFD4CFC8),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: _isProcessing 
                                ? const Color(0xFFD4CFC8) 
                                : const Color(0xFFBCAAA4),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    // 処理完了後の「次へ」ボタン
                    if (_processedImageFile != null && !_isProcessing) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: 次の画面（顔を描く画面）へ遷移
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('次の画面は開発中です'),
                                backgroundColor: Color(0xFF9E8B7E),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward, size: 24),
                          label: const Text(
                            '次へ進む',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9E8B7E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
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