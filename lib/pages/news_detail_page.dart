import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/models/article_detail.dart';
import 'package:news_app_202504/pages/home_page.dart';
import 'package:news_app_202504/pages/news_list_page.dart';
import 'package:news_app_202504/services/api_service.dart';

class NewsDetailPage extends StatefulWidget {
  final String title; // ← article_detail.dartからとってくる
  const NewsDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  NewsDetailData? _detail;
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    NewsApi()
        .getArticleDetailByTitle(widget.title)
        .then((data) {
          setState(() {
            _detail = data;
            _isLoading = false;
          });
        })
        .catchError((e) {
          setState(() {
            _error = e.toString();
            _isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('エラー: $_error'));
    }
    final detail = _detail!;
    final Set<String> _favoriteTitles = {}; // タイトルをキーにしてファボを登録
    final isFav = _favoriteTitles.contains(
      widget.title,
    ); // ファボ登録記事がタイトルを含んでいたらisFavがtrue

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 記事タイトル
              Text(
                widget.title,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (detail.urlToImage.isNotEmpty)
                Image.network(
                  detail.urlToImage,
                  fit: BoxFit.cover,
                  height: 200, // お好みで高さ指定
                ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.text_fields),
                    SizedBox(width: 12.0),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color:
                            isFav
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFav)
                            _favoriteTitles.remove(widget.title);
                          else
                            _favoriteTitles.add(widget.title);
                        });
                      },
                    ),
                    SizedBox(width: 12.0),
                    Icon(Icons.share),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                detail.description,
                style: const TextStyle(fontSize: 16.0, height: 1.5),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'TOP'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '一覧へ戻る'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'お気に入り'),
        ],
        onTap: (index) {
          setState(
            () => _currentIndex = index, //押されたタブのインデックス更新
          );
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 1) {
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
