import 'dart:convert'; // JSON のエンコード／デコード機能を使うためのライブラリ
import 'package:http/http.dart' as http; // ▶ HTTP リクエストを送る http パッケージをインポート
import 'package:news_app_202504/models/article_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app_202504/models/article_detail.dart'; // detail用のモデルをインポート

// APIを使うクラス(// ニュース取得ロジックをまとめるクラス)
class NewsApi {
  // API KEYを使う変数
  final String _apiKey =
      dotenv.env['NEWS_API_KEY'] ?? ''; // ▶ 取得した API キーを保持（実運用では秘匿）
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  // 🔥 ログ付きのニュース取得関数（一覧）
  Future<List<NewsDetailData>> loadNews({String country = 'us'}) async {
    final uri = '$_baseUrl?country=$country&apiKey=$_apiKey';
    print('🌐 リクエストURL: $uri');
    print('🔑 APIキー: $_apiKey');

    try {
      final http.Response response = await http.get(Uri.parse(uri));
      print('📩 ステータスコード: ${response.statusCode}');
      print('📦 レスポンスボディ: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> articlesJson =
            jsonData['articles'] as List<dynamic>;
        print('🟢 APIからの記事数: ${articlesJson.length}');
        return articlesJson
            .map((articleJson) => NewsDetailData.fromJson(articleJson))
            .toList();
      } else {
        print('🛑 エラー: ステータスコード ${response.statusCode}');
        throw Exception('ニュースの取得に失敗しました');
      }
    } catch (e) {
      print('❌ 例外発生: $e');
      throw Exception('通信エラーが発生しました');
    }
  }

  // 🔍 詳細取得メソッド（title検索）
  Future<NewsDetailData> getArticleDetailByTitle(String title) async {
    final uri = Uri.parse(
      '$_baseUrl'
      '?country=us'
      '&q=${Uri.encodeComponent(title)}'
      '&pageSize=1'
      '&apiKey=$_apiKey',
    );

    final http.Response response = await http.get(uri);
    print('📩 ステータスコード: ${response.statusCode}');
    print('📦 レスポンスボディ: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('ニュースの取得に失敗しました');
    }
    final jsonData = jsonDecode(response.body);
    final List<dynamic> articles = jsonData['articles'] as List<dynamic>;
    print('🟢 APIからの記事数: ${articles.length}');

    if (articles.isEmpty) {
      throw Exception('該当する記事が見つかりませんでした');
    }
    return NewsDetailData.fromJson(articles[0] as Map<String, dynamic>);
  }
}
