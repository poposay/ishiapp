import 'package:flutter/material.dart';
import 'tutorial_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // タイトル「いしコロ」
              const Text(
                'いしコロ',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3D2817),
                  letterSpacing: 8,
                ),
              ),

              const SizedBox(height: 12),

              // サブタイトル
              const Text(
                '石に命を、毎日に癒しを。',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8A8A8A),
                  letterSpacing: 2,
                ),
              ),

              const Spacer(flex: 1),

              // 石のキャラクター画像
              Image.asset(
                'assets/images/ishikoro.png',
                width: 400,
                height: 320,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 2),

              // 「はじめる」ボタン
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TutorialScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4CFC8),
                  foregroundColor: const Color(0xFF6A6A6A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'はじめる',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // バージョン表示
              const Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB0B0B0),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}