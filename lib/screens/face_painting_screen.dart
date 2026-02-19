import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'home_screen.dart';

// グレージュ系カラー定数（splash / tutorial と共通）
const _kBrown = Color(0xFF3D2817);
const _kGreige = Color(0xFFD4CFC8);
const _kGreigeDeep = Color(0xFFB8AFA5);
const _kTextGrey = Color(0xFF6A6A6A);
const _kBgGreige = Color(0xFFF0EBE5);

class FacePaintingScreen extends StatefulWidget {
  final Uint8List stoneImage;

  const FacePaintingScreen({super.key, required this.stoneImage});

  @override
  State<FacePaintingScreen> createState() => _FacePaintingScreenState();
}

class _FacePaintingScreenState extends State<FacePaintingScreen> {
  // 描画した線のリスト
  final List<DrawingStroke> _strokes = [];

  // 現在の描画設定
  Color _selectedColor = Colors.black;
  double _strokeWidth = 5.0;
  bool _isEraser = false;

  // 描画領域のキー（画像生成用）
  final GlobalKey _canvasKey = GlobalKey();

  // カラーパレット
  final List<Color> _colors = [
    Colors.black,
    const Color(0xFF8B3A3A), // ダークレッド
    const Color(0xFF3A5F8B), // ダークブルー
    const Color(0xFF4A7A4A), // ダークグリーン
    const Color(0xFFD4A847), // ゴールド
    const Color(0xFF7A4A8B), // プラム
    Colors.white,
  ];

  // ペンの太さ
  final List<double> _strokeSizes = [3.0, 8.0, 15.0];

  /// 最後のストロークを取り消す
  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() => _strokes.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgGreige,
      appBar: AppBar(
        backgroundColor: _kGreige,
        foregroundColor: _kBrown,
        elevation: 0,
        title: const Text(
          '顔を描こう',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: _kBrown,
            letterSpacing: 4,
          ),
        ),
        iconTheme: const IconThemeData(color: _kBrown),
        actions: [
          // Undoボタン
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'もどす',
            onPressed: _strokes.isEmpty ? null : _undo,
            color: _strokes.isEmpty ? _kGreigeDeep : _kBrown,
          ),
          // 完了ボタン
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _saveAndNavigate,
              style: TextButton.styleFrom(
                backgroundColor: _kGreigeDeep,
                foregroundColor: _kBrown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text(
                'できた',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // キャンバスエリア
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _canvasKey,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ベースの石画像
                    Image.memory(
                      widget.stoneImage,
                      fit: BoxFit.contain,
                    ),
                    // 描画レイヤー
                    Positioned.fill(
                      child: GestureDetector(
                        onPanStart: (details) {},
                        onPanUpdate: (details) {
                          setState(() {
                            if (_strokes.isNotEmpty) {
                              _strokes.last.points.add(details.localPosition);
                            }
                          });
                        },
                        onPanDown: (details) {
                          setState(() {
                            _strokes.add(DrawingStroke(
                              paint: Paint()
                                ..color = _isEraser
                                    ? Colors.transparent
                                    : _selectedColor
                                ..strokeWidth = _strokeWidth
                                ..strokeCap = StrokeCap.round
                                ..style = PaintingStyle.stroke
                                ..blendMode = _isEraser
                                    ? BlendMode.clear
                                    : BlendMode.srcOver,
                              points: [details.localPosition],
                            ));
                          });
                        },
                        child: CustomPaint(
                          painter: FacePainter(_strokes),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ツールバー
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: const BoxDecoration(
        color: _kGreige,
        border: Border(
          top: BorderSide(color: _kGreigeDeep, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 太さ選択 ＋ Undoボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 「一つ前に戻る」ボタン
              GestureDetector(
                onTap: _strokes.isEmpty ? null : _undo,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _strokes.isEmpty ? Colors.transparent : _kGreigeDeep,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _strokes.isEmpty ? _kGreigeDeep : _kBrown,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.undo,
                        size: 16,
                        color: _strokes.isEmpty ? _kGreigeDeep : _kBrown,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'もどす',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _strokes.isEmpty ? _kGreigeDeep : _kBrown,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // ペンの太さ選択
              ..._strokeSizes.map((size) {
                final isSelected = _strokeWidth == size;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _strokeWidth = size),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected ? _kGreigeDeep : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? _kBrown : _kGreigeDeep,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: size,
                          height: size,
                          decoration: const BoxDecoration(
                            color: _kBrown,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          // 色選択と消しゴム
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._colors.map((color) {
                  final isSelected = _selectedColor == color && !_isEraser;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedColor = color;
                        _isEraser = false;
                      }),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? _kBrown : _kGreigeDeep,
                            width: isSelected ? 2.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _kBrown.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                // 消しゴムボタン
                GestureDetector(
                  onTap: () => setState(() => _isEraser = true),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _isEraser ? _kGreigeDeep : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isEraser ? _kBrown : _kGreigeDeep,
                        width: _isEraser ? 2.0 : 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.cleaning_services,
                      size: 18,
                      color: _kTextGrey,
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

  Future<void> _saveAndNavigate() async {
    try {
      RenderRepaintBoundary boundary =
          _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(stoneWithFaceImage: pngBytes),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
  }
}

class DrawingStroke {
  final Paint paint;
  final List<Offset> points;

  DrawingStroke({required this.paint, required this.points});
}

class FacePainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  FacePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);

      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }

      canvas.drawPath(path, stroke.paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
