import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 追加パッケージ
import 'package:news_app_202504/main.dart';
import 'package:news_app_202504/pages/home_page.dart';
import 'package:news_app_202504/pages/news_detail_page.dart';
import 'package:news_app_202504/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/providers/articles_provider.dart';
import 'package:news_app_202504/pages/news_detail_page.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final Set<int> _favoriteIndexes = {}; // 押されたら登録／解除する index の集合
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // provider経由で記事取得
      context.read<ArticlesProvider>().loadArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // providerを参照する
    final provider = context.watch<ArticlesProvider>();
    final list = provider.articles!;

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
      body: (() {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (list == null) {
          return const Center(child: Text('記事を取得できませんでした'));
        }
        if (list.isEmpty) {
          return const Center(child: Text('記事がまだありません'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            // 現在この行がお気に入り済みかどうか
            final isFav = _favoriteIndexes.contains(index);
            return ListTile(
              leading:
                  item.urlToImage.isNotEmpty
                      ? Image.network(
                        item.urlToImage,
                        width: 40,
                        fit: BoxFit.cover,
                        // 画像がうまく表示できずエラーになったときの対策
                        errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return const Icon(Icons.article, size: 40);
                        },
                      )
                      // urlToImageが空だったとき
                      : const Icon(Icons.article, size: 40),
              title: Text(item.title),
              // 星を右端に置く
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color:
                      isFav
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isFav)
                      _favoriteIndexes.remove(index);
                    else
                      _favoriteIndexes.add(index);
                  });
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewsDetailPage(title: item.title),
                    //(title: item.title),
                  ),
                );
              },
            );
          },
        );
      }()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'TOP'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '一覧'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'お気に入り'),
        ],
        onTap: (index) {
          setState(
            () => _currentIndex = index, //押されたタブのインデックス更新
          );
          if (index == 0) {
            Navigator.pop(context);
          }
          // if (index == 2) {
          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(builder: (context) => const NewsDetailPage()),
          //   // );
          // }
        },
      ),
    );
  }
}
