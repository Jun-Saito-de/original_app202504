import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app_202504/providers/articles_provider.dart';
import 'package:news_app_202504/pages/news_list_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  // mian.dartから渡された「今のモード」と「切替関数」をコンストラクタで受け取る
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;

  const HomePage({
    Key? key,
    required this.title,
    required this.isDarkMode,
    required this.onThemeToggle,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isDarkMode = false;

  final Set<String> _favoriteTitles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   title: Text(
      //     'NEWS EXPRESS',
      //     style: TextStyle(
      //       color: Theme.of(context).colorScheme.onPrimary,
      //       fontSize: 24.0,
      //       fontWeight: FontWeight.w800,
      //       fontFamily: "LexendDeca",
      //       letterSpacing: -0.5,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    greeting(), // 挨拶関数
                    style: TextStyle(fontSize: 24),
                  ), // 時間帯によって表示するメッセージを変える
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.sunny),
                      SizedBox(width: 10),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: widget.isDarkMode, // 親の _mode == dark を反映
                          onChanged:
                              widget
                                  .onThemeToggle, // 親の setState() を呼ぶ（親を更新 → アプリ再描画）
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.nightlight_round),
                    ],
                  ),
                  SizedBox(height: 80.0),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage(
                      'assets/images/newsexpress_logo.png',
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'NEWS EXPRESS',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "LexendDeca",
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  NewsListPage(favoriteTitles: _favoriteTitles),
                        ),
                      );
                    },
                    child: const Text(
                      'ニュース一覧へ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onThemeToggle(bool? value) {
    setState(() {
      isDarkMode = value!;
    });
  }

  // 挨拶文のif文
  String greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour <= 10) {
      return 'おはようございます！';
    } else if (hour >= 11 && hour <= 17) {
      return 'こんにちは！';
    } else {
      return 'こんばんは！';
    }
  }
}
