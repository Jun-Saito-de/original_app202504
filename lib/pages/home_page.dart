// home_page.dart: ホーム画面のウィジェット定義
// HomePage はアプリのルートに近い画面で、main.dart からテーマ切替やタイトルなどの設定情報を受け取る
// 記事一覧や詳細ページは Provider や Navigator 経由で必要な情報を取得するため、
// コンストラクタでパラメータを渡す必要はありません
// 例: 記事データは ArticlesProvider, お気に入り情報は FavoritesProvider から取得されるため

import 'package:flutter/material.dart';
import 'package:news_app_202504/pages/news_list_page.dart'; // ニュース一覧画面への遷移に使用

// StatefulWidget を継承して、内部状態を持つホームページを定義
class HomePage extends StatefulWidget {
  // main.dart から渡されるプロパティを定義
  final String title; // AppBar やヘッダーで表示するタイトル
  final bool isDarkMode; // 現在ダークモードが有効かどうか
  final ValueChanged<bool> onThemeToggle; // テーマ変更イベントを親に伝えるコールバック

  // Widget を生成する際に必要な情報を親から受け取るコンストラクタ
  // - Key? key: ウィジェット固有のキー。Flutter のウィジェットツリー管理に使われる
  // - required this.title: 画面ヘッダーに表示するタイトル文字列を必須で受け取る
  // - required this.isDarkMode: 現在ダークモードかどうかの初期状態を必須で受け取る
  // - required this.onThemeToggle: テーマ切替スイッチが操作されたときのコールバック関数を必須で受け取る
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea: デバイスのノッチやステータスバーを避ける
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 上から配置
          crossAxisAlignment: CrossAxisAlignment.stretch, // 横いっぱいに広げる
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 挨拶テキスト
                  Text(greeting(), style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 16.0),

                  // ダーク/ライトテーマ切替スイッチ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.sunny), // ライトのアイコン
                      const SizedBox(width: 10),
                      Transform.scale(
                        scale: 0.8, // スイッチを小さく表示
                        child: Switch(
                          // widget. は StatefulWidget のプロパティへのアクセスに必要
                          value: widget.isDarkMode, // 親が渡したテーマ状態を反映
                          onChanged: widget.onThemeToggle, // 親から渡されたコールバックを実行
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.nightlight_round), // ダークのアイコン
                    ],
                  ),
                  const SizedBox(height: 80.0),

                  // ロゴやキャッチフレーズ
                  const CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage(
                      'assets/images/newsexpress_logo.png',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    widget.title, // コンストラクタで渡されたタイトルを表示
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary, // テーマ色を使用
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LexendDeca',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ニュース一覧へ遷移するボタン
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewsListPage(),
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

  // 時間帯に応じた挨拶を返すヘルパーメソッド
  String greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour <= 10) {
      return 'おはようございます！';
    } else if (hour >= 11 && hour <= 17) {
      return 'こんにちは！';
    }
    return 'こんばんは！';
  }
}
