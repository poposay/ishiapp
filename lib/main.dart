import 'package:flutter/material.dart';

void main() {
  runApp(const IshiApp());
}

class IshiApp extends StatelessWidget {
  const IshiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'いしコロ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD7CCC8), // グレージュ
          primary: const Color(0xFFBCAAA4),
          secondary: const Color(0xFFA1887F),
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F3F0), // ライトグレージュ
              Color(0xFFE8E3DF), // グレージュ
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // タイトル
                Text(
                  'いしコロ',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                    color: const Color(0xFF6D5D52),
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // サブタイトル
                const Text(
                  '石に命を、毎日に癒しを',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    color: Color(0xFF9E8B7E),
                  ),
                ),
                
                const SizedBox(height: 80),
                
                // 石のイラスト
                Container(
                  width: 220,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFFD4C8BF),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(-10, -10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // 目
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF6D5D52).withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(width: 45),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF6D5D52).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // 口
                        Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF6D5D52).withOpacity(0.6),
                              width: 2.5,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 100),
                
                // はじめるボタン
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9E8B7E).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 次の画面へ遷移
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('開発中です...'),
                          backgroundColor: const Color(0xFF9E8B7E),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBCAAA4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'はじめる',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // バージョン情報
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    'v0.1.0',
                    style: TextStyle(
                      color: const Color(0xFF9E8B7E).withOpacity(0.5),
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}