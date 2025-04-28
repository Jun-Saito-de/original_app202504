import 'package:flutter/material.dart';
import 'package:news_app_202504/main.dart';
import 'package:news_app_202504/pages/news_list_page.dart';
import 'package:news_app_202504/pages/news_detail_page.dart';

class FavoriteListPage extends StatefulWidget {
  // favoriteTitlesにWidget側でデータを受け取る
  final Set<String> favoriteTitles;
  // FavoriteListPage WidgetにfavoriteTitlesを渡す
  const FavoriteListPage({super.key, required this.favoriteTitles});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  @override
  Widget build(BuildContext context) {
    final favorites = widget.favoriteTitles.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NEWS EXPRESS',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: "LexendDeca",
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body:
          favorites.isEmpty
              ? const Center(child: Text('お気に入りがまだありません'))
              : ListView(
                children:
                    widget.favoriteTitles.map((title) {
                      // 子供クラスから親クラスのプロパティにアクセスするためwidget.をつける
                      return ListTile(title: Text(title), onTap: () {});
                    }).toList(),
              ),
    );
  }
}
