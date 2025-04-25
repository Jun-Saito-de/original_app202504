import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/models/article_list.dart';
import 'package:news_app_202504/services/api_service.dart';

class ArticlesProvider extends ChangeNotifier {
  final NewsApi _api = NewsApi();
  bool _isLoading = false; // 「今ちょうど記事を取得中かどうか」を Provider で保持するためのもの
  bool get isLoading => _isLoading;
  List? _articles;
  List? get articles => _articles;

  Future<void> loadArticles() async {
    _isLoading = true; // API呼び出し前に読み込み開始
    notifyListeners();
    try {
      _articles = await NewsApi().loadNews(); // API呼び出し 記事を受け取る処理が終わるまで
    } catch (e) {
      _articles = []; // エラー管理
    } finally {
      _isLoading = false; // 読み込み終了
      notifyListeners(); // UIに読み込み終了を通知
    }
  }
}
