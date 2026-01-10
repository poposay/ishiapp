import 'package:flutter/material.dart';
import 'capture_screen.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

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
            children: [
              const SizedBox(height: 60),

              // タイトル
              const Text(
                'いしコロの飼い方',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3D2817),
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: 60),

              // チュートリアル項目
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _buildTutorialItem(
                          number: '1',
                          title: '気に入る石を見つけたら',
                          subtitle: '写真を撮りましょう。',
                          image: 'assets/images/snap.png',
                        ),
                        const SizedBox(height: 40),
                        _buildTutorialItem(
                          number: '2',
                          title: 'お好みで顔を描きましょう。',
                          subtitle: '',
                          image: 'assets/images/draw.png',
                        ),
                        const SizedBox(height: 40),
                        _buildTutorialItem(
                          number: '3',
                          title: 'いしコロの誕生！',
                          subtitle: '',
                          image: 'assets/images/ok.png',
                        ),
                        const SizedBox(height: 40),
                        _buildTutorialItem(
                          number: '4',
                          title: 'お水をかけたり、磨いたりして',
                          subtitle: '大切に育てましょう。',
                          image: 'assets/images/care.png',
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),

              // 「つぎへ」ボタン
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const CaptureScreen(),
                    ),
                  );
                 },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4CFC8),
                    foregroundColor: const Color(0xFF6A6A6A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'つぎへ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialItem({
    required String number,
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 番号
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFB8AFA5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // テキスト部分
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3D2817),
                  height: 1.6,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3D2817),
                    height: 1.6,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // 画像
              Image.asset(
                image,
                height: 160,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ],
    );
  }
}