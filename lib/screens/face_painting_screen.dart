import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'home_screen.dart';

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
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.white,
  ];

  // ペンの太さ
  final List<double> _strokeSizes = [3.0, 8.0, 15.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('顔を描こう'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAndNavigate,
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
                        onPanStart: (details) {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          // Stackの基準位置などを考慮する必要があるが、
                          // ここではGestureDetectorがPositioned.fillで全画面（Stack内）を覆っていると仮定
                          // renderBox.globalToLocalだと画面全体の座標になるため、
                          // Positioned.fill内のローカル座標を取得する
                          final box = context.findRenderObject() as RenderBox?;
                          // このGestureDetectorはStackの子なので、local positionでOKなはずだが
                          // 正確にはRepaintBoundary内の相対座標が欲しい
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            // 現在のストロークにポイントを追加
                            if (_strokes.isNotEmpty) {
                              _strokes.last.points.add(details.localPosition);
                            }
                          });
                        },
                        onPanDown: (details) {
                          setState(() {
                            // 新しいストロークを開始
                            _strokes.add(DrawingStroke(
                              paint: Paint()
                                ..color = _isEraser ? Colors.transparent : _selectedColor
                                ..strokeWidth = _strokeWidth
                                ..strokeCap = StrokeCap.round
                                ..style = PaintingStyle.stroke
                                ..blendMode = _isEraser ? BlendMode.clear : BlendMode.srcOver,
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
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 太さ選択
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _strokeSizes.map((size) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () => setState(() => _strokeWidth = size),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _strokeWidth == size ? Colors.grey[400] : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Container(
                        width: size,
                        height: size,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // 色選択と消しゴム
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._colors.map((color) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
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
                            color: _selectedColor == color && !_isEraser ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 10),
                // 消しゴムボタン
                InkWell(
                  onTap: () => setState(() => _isEraser = true),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isEraser ? Colors.grey[400] : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(Icons.cleaning_services), // Eraser icon substitute
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
      // RepaintBoundaryから画像をキャプチャ
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
    // レイヤー合成のための設定（消しゴム機能のため）
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
      
      for (int i = 1; i < stroke.points.length; i++) {
        // 単純な直線でつなぐが、油性ペン風にするならここでノイズを入れても良い
        // 今回はPaintの設定でStrokeCap.roundにしているのでプロトタイプとしては十分
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }

      canvas.drawPath(path, stroke.paint);
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
