import 'dart:convert'; // JSON のエンコード／デコード機能を使うためのライブラリ
import 'package:http/http.dart' as http; // ▶ HTTP リクエストを送る http パッケージをインポート
import 'package:news_app_202504/models/article.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// APIを使うクラス(// ニュース取得ロジックをまとめるクラス)

class NewsApi {
  // API KEYを使う変数
  final String _apiKey =
      dotenv.env['NEWS_API_KEY'] ?? ''; // ▶ 取得した API キーを保持（実運用では秘匿）
  // 日本の情報のURL (ベースとなるエンドポイントの URL)
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  // APIからデータを取得するメソッド（JSON読み込み関数）
  Future<List<NewsData>> loadNews({
    String country = 'jp', // ▶ デフォルトは日本 (jp)
  }) async {
    // getメソッドでデータを取得
    // parseメソッドの引数にURIのテキストを指定。このURIにhttpsが指定されていればhttpsでアクセスを行う
    // ─── 1) GET リクエストを送信 ─────────────────
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl?country=jp&apiKey=$_apiKey'),
    );
    // ─── 2) ステータスコードが 200（OK）かチェック ───
    if (response.statusCode == 200) {
      // JSONのデータを元のデータに戻す
      // ─── 3) JSON 文字列を Dart の Map に変換
      final jsonData = jsonDecode(response.body);
      // ─── 4) 'articles' 配列を取り出して List<dynamic> に ─
      // mapメソッドで、Map型のデータをListに変換する
      // final List<dynamic> articlesJson = jsonData['記事一覧'];
      final List<dynamic> articlesJson = jsonData['articles'] as List<dynamic>;
      // ─── 5) Map → Article オブジェクトに変換し、List<Article> を返す ─
      return articlesJson
          .map((articleJson) => NewsData.fromJson(articleJson))
          .toList();
    } else {
      throw Exception('ニュースの取得に失敗しました');
    }
  }
}
