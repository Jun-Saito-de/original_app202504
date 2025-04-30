import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 追加パッケージ
import 'package:news_app_202504/main.dart';
import 'package:news_app_202504/pages/home_page.dart';
import 'package:news_app_202504/pages/news_detail_page.dart';
import 'package:news_app_202504/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/providers/articles_provider.dart';
import 'package:news_app_202504/providers/favorites_provider.dart';
import 'package:news_app_202504/pages/news_list_page.dart';

class FavoriteListPage extends StatelessWidget {
  // favoriteTitlesにWidget側でデータを受け取る
  // final Set<String> favoriteTitles;
  // FavoriteListPage WidgetにfavoriteTitlesを渡す
  const FavoriteListPage({super.key});

  //   @override
  //   State<FavoriteListPage> createState() => _FavoriteListPageState();
  // }

  // class _FavoriteListPageState extends State<FavoriteListPage> {

  @override
  Widget build(BuildContext context) {
    // final favProv = context.watch<FavoritesProvider>();
    final favorites = context.watch<FavoritesProvider>().favorites.toList();
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
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final title = favorites[index];
                  return ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailPage(title: title),
                        ),
                      );
                    },
                  );
                },
                // 子供クラスから親クラスのプロパティにアクセスするためwidget.をつける
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'TOP'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '一覧へ戻る'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
