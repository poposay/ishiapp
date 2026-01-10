import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RemoveBgService {
  // Remove.bg APIキー
  static const String _apiKey = 'eZSbq66zicRZawKWxnPXmcXF';

  /// 背景を除去する
  static Future<File?> removeBackground(File imageFile) async {
    try {
      print('背景除去を開始...');
      
      // Remove.bg APIにリクエスト
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.remove.bg/v1.0/removebg'),
      );

      // APIキーをヘッダーに追加
      request.headers['X-Api-Key'] = _apiKey;

      // 画像ファイルを追加
      request.files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );

      // 画像サイズの設定
      request.fields['size'] = 'auto';

      // リクエストを送信
      var response = await request.send();

      if (response.statusCode == 200) {
        print('背景除去成功！');
        
        // レスポンスの画像データを取得
        final bytes = await response.stream.toBytes();
        
        // 一時ファイルとして保存
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${tempDir.path}/removed_bg_$timestamp.png');
        await file.writeAsBytes(bytes);
        
        return file;
      } else {
        print('背景除去失敗: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('エラー詳細: $responseBody');
        return null;
      }
    } catch (e) {
      print('背景除去エラー: $e');
      return null;
    }
  }
}