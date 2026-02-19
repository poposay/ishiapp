import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// splash / tutorial と共通カラー定数
const _kGreige = Color(0xFFD4CFC8);
const _kTextGrey = Color(0xFF8A8A8A);
const _kGold = Color(0xFFFFE066);
const _kGoldDeep = Color(0xFFD4A847);

class PolishScreen extends StatefulWidget {
  final Uint8List stoneImage;
  final String backgroundImage;

  const PolishScreen({
    super.key,
    required this.stoneImage,
    required this.backgroundImage,
  });

  @override
  State<PolishScreen> createState() => _PolishScreenState();
}

class _PolishScreenState extends State<PolishScreen>
    with TickerProviderStateMixin {
  // オーディオプレイヤー
  final AudioPlayer _audioPlayer = AudioPlayer();

  // スパークルリスト（位置・アニメーション）
  final List<_Sparkle> _sparkles = [];

  // ドラッグ中フラグ（音の連続再生制御）
  bool _isPolishing = false;

  // 案内テキスト表示フラグ
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    for (final s in _sparkles) {
      s.controller.dispose();
    }
    super.dispose();
  }

  // ドラッグ開始・更新で呼ぶ
  Future<void> _onPolish(Offset localPosition) async {
    // ヒントを消す
    if (_showHint) {
      setState(() => _showHint = false);
    }

    // 触覚フィードバック
    HapticFeedback.lightImpact();

    // 音を再生（再生中でなければ）
    if (!_isPolishing) {
      _isPolishing = true;
      await _audioPlayer.play(AssetSource('audio/squeak.mp3'));
    }

    // スパークル追加
    _addSparkle(localPosition);
  }

  void _onPolishEnd() {
    _isPolishing = false;
    _audioPlayer.stop();
  }

  void _addSparkle(Offset position) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    final sparkle = _Sparkle(
      position: position,
      controller: controller,
    );

    setState(() => _sparkles.add(sparkle));

    controller.forward().then((_) {
      if (mounted) {
        setState(() => _sparkles.remove(sparkle));
        controller.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景画像
          Positioned.fill(
            child: Image.asset(
              widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          // コンテンツ
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),

                // 案内テキスト：Opacityで表示/非表示を切り替えてレイアウトを固定
                GestureDetector(
                  onTap: () => setState(() => _showHint = false),
                  child: Opacity(
                    opacity: _showHint ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.8),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'いしコロをやさしく磨いてあげましょう',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3D2817),
                            letterSpacing: 2,
                            height: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // 石の画像 + スパークルオーバーレイ
                GestureDetector(
                  onPanStart: (d) => _onPolish(d.localPosition),
                  onPanUpdate: (d) => _onPolish(d.localPosition),
                  onPanEnd: (_) => _onPolishEnd(),
                  onPanCancel: _onPolishEnd,
                  child: SizedBox(
                    width: 320,
                    height: 320,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 石画像
                        Center(
                          child: Image.memory(
                            widget.stoneImage,
                            width: 280,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // スパークルレイヤー
                        ..._sparkles.map((s) => _SparkleWidget(sparkle: s)),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // おわるボタン
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGreige,
                      foregroundColor: const Color(0xFF3D2817),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 64, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'おわる',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- スパークルデータモデル ----
class _Sparkle {
  final Offset position;
  final AnimationController controller;

  _Sparkle({required this.position, required this.controller});
}

// ---- スパークルウィジェット ----
class _SparkleWidget extends StatelessWidget {
  final _Sparkle sparkle;

  const _SparkleWidget({required this.sparkle});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sparkle.controller,
      builder: (_, __) {
        final t = sparkle.controller.value;
        // フェード: 0→1→0 (上がって消える)
        final opacity = t < 0.5 ? t * 2 : (1 - t) * 2;
        final scale = 0.3 + t * 1.2;

        return Positioned(
          left: sparkle.position.dx - 16,
          top: sparkle.position.dy - 16,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: CustomPaint(
                size: const Size(32, 32),
                painter: _StarPainter(),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---- 星型ペインター ----
class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFE066)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFFD4A847)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = _starPath(size.width / 2, size.height / 2, 5,
        size.width / 2, size.width / 4.5);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  Path _starPath(
      double cx, double cy, int points, double outerR, double innerR) {
    final path = Path();
    final step = pi / points;
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = -pi / 2 + i * step;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}