import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'polish_screen.dart';

class HomeScreen extends StatefulWidget {
  final Uint8List stoneWithFaceImage;

  const HomeScreen({super.key, required this.stoneWithFaceImage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _stoneName = ' ';
  final TextEditingController _nameController = TextEditingController();

  // 背景画像リスト（デフォルトはbg_home.png）
  final List<String> _bgImages = [
    'assets/images/bg_home.png',
    'assets/images/bg_home2.png',
    'assets/images/bg_home3.png',
  ];
  int _bgIndex = 0;

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
          title: const Text('いしコロに名前をつけましょう'),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_bgImages[_bgIndex]),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea( // SafeAreaで囲んでUIが隠れないようにする
          child: Column(
            children: [
              // 背景切り替えボタン
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_bgImages.length, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => _bgIndex = i),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _bgIndex == i ? Colors.brown : Colors.transparent,
                                width: 2.5,
                              ),
                              image: DecorationImage(
                                image: AssetImage(_bgImages[i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),

              // 名前表示エリア
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _stoneName.isEmpty ? '' : _stoneName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3D2817),
                      letterSpacing: 4,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PolishScreen(
                            stoneImage: widget.stoneWithFaceImage,
                            backgroundImage: _bgImages[_bgIndex],
                          ),
                        ),
                      );
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
        backgroundColor: const Color(0xFFD4CFC8),
        foregroundColor: const Color(0xFF6A6A6A),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
