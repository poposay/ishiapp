import 'dart:typed_data';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Uint8List stoneWithFaceImage;

  const HomeScreen({super.key, required this.stoneWithFaceImage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _stoneName = ' ';
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 画面描画後にダイアログを表示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNamingDialog();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showNamingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 名前を決めるまで閉じられないようにする
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('石コロに名前をつけましょう'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "名前を入力"),
          ),
          actions: <Widget>[
              TextButton(
              child: const Text('決定'),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  setState(() {
                    _stoneName = _nameController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea( // SafeAreaで囲んでUIが隠れないようにする
          child: Column(
            children: [
              // 名前表示エリア
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _stoneName.isEmpty ? '' : _stoneName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // 石の画像
              Center(
                child: Image.memory(
                  widget.stoneWithFaceImage,
                  width: 300, // 適度なサイズに制限
                  fit: BoxFit.contain,
                ),
              ),
              
              const Spacer(),
              
              // お世話ボタンエリア
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCareButton('磨く', Icons.cleaning_services_outlined, () {
                      debugPrint('磨くボタンが押されました');
                    }),
                    _buildCareButton('洗う', Icons.water_drop_outlined, () {
                      debugPrint('洗うボタンが押されました');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCareButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 4,
      ),
    );
  }
}
