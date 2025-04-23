import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/models/article.dart';
import 'package:news_app_202504/services/api_service.dart';

class ArticlesProvider extends ChangeNotifier {
  final NewsApi _api = NewsApi();
  List? _articles;
  List? get articles => _articles;

  Future<void> loadArticles() async {
    _articles = await _api.loadNews(); //API呼び出し
    notifyListeners();
  }
}
