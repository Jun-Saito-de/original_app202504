import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/models/news_detail_data.dart';
import 'package:news_app_202504/services/api_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:news_app_202504/providers/favorites_provider.dart';
import 'package:news_app_202504/pages/favorite_list_page.dart';

class NewsDetailPage extends StatefulWidget {
  final String title;
  const NewsDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  NewsDetailData? _detail;
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;
  double _charSize = 16.0;

  void _shareText() {
    final text = '${widget.title}\n\n${_detail?.description ?? ''}';
    Share.share(text);
  }

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
    final favProv = context.watch<FavoritesProvider>();
    final isFav = favProv.favorites.contains(widget.title);

    return Scaffold(
      appBar: AppBar(title: const Text('NEWS EXPRESS'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (detail.urlToImage.isNotEmpty)
                Image.network(
                  detail.urlToImage,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.text_fields),
                    onPressed: () {
                      setState(() {
                        if (_charSize == 16.0) {
                          _charSize = 20.0;
                        } else if (_charSize == 20.0) {
                          _charSize = 12.0;
                        } else {
                          _charSize = 16.0;
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 12.0),
                  IconButton(
                    icon: Icon(isFav ? Icons.star : Icons.star_border),
                    onPressed: () {
                      favProv.toggle(widget.title);
                    },
                  ),
                  const SizedBox(width: 12.0),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareText,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                detail.description,
                style: TextStyle(fontSize: _charSize, height: 1.5),
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
          setState(() => _currentIndex = index);
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pop(context);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteListPage()),
            );
          }
        },
      ),
    );
  }
}
