// main.dart: アプリ起動とテーマ切り替え、Provider設定を行うエントリポイント

import 'package:flutter/material.dart';
import 'package:news_app_202504/providers/articles_provider.dart';
import 'package:news_app_202504/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// main 関数は async にして、Flutter 実行前に .env から環境変数をロード
Future<void> main() async {
  // Flutter のバインディングを初期化（非同期処理前に呼ぶ必要がある）
  WidgetsFlutterBinding.ensureInitialized();

  // .env ファイルから API キーなどの環境変数を読み込む
  await dotenv.load(fileName: '.env');

  // runApp で MultiProvider を使い、アプリ全体で Provider を提供
  runApp(
    MultiProvider(
      providers: [
        // 記事一覧取得用 Provider
        ChangeNotifierProvider(create: (_) => ArticlesProvider()),
        // お気に入り管理用 Provider
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      // MyApp を子ウィジェットに渡す
      child: const MyApp(),
    ),
  );
}

// MyApp は StatefulWidget で、テーマの状態（ライト/ダーク）を保持
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // _mode で現在のテーマモードを管理（初期はライト）
  ThemeMode _mode = ThemeMode.light;

  // トグルスイッチ操作時に呼ばれる。
  // 引数 isDark はスイッチの新しい状態を表し、trueのときダークモード、falseのときライトモードに切り替えます。
  void _toggleTheme(bool isDark) {
    setState(() {
      _mode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリのタイトル
      title: 'news express',

      // ライトテーマ設定
      theme: ThemeData.light().copyWith(
        // 背景色を白に固定
        scaffoldBackgroundColor: Colors.white,
        // カラースキームをライトテーマからコピーしてカスタム
        colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: const Color.fromARGB(255, 3, 72, 179), // プライマリーカラー
          onPrimary: Colors.white, // プライマリー上のテキスト色
          secondary: const Color.fromARGB(255, 70, 165, 240), // アクセントカラー
          onSecondary: const Color.fromARGB(255, 30, 30, 30),
          brightness: Brightness.light, // 明るさをライト
          error: Colors.red, // エラー色
          onError: Colors.white,
          onSurface: const Color.fromARGB(255, 30, 30, 30),
          surface: Colors.white,
        ),
        // ボタンの共通スタイル設定
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 230, 230, 230),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // AppBar のスタイル
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 3, 72, 179),
          foregroundColor: ThemeData.light().colorScheme.onPrimary,
          elevation: 2,
        ),
        // BottomNavigationBar のスタイル
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 3, 72, 179),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),

      // ダークテーマ設定（ライトと同様に copyWith でカスタム）
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: const Color.fromARGB(255, 245, 245, 245),
          onPrimary: Colors.black,
          secondary: const Color.fromARGB(255, 245, 245, 245),
          onSecondary: const Color.fromARGB(255, 30, 30, 30),
          brightness: Brightness.dark,
          error: Colors.red,
          onError: Colors.white,
          onSurface: Colors.white,
          surface: Colors.grey.shade900,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeData.dark().colorScheme.surface,
          foregroundColor: ThemeData.dark().colorScheme.onSurface,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ThemeData.dark().colorScheme.surface,
          selectedItemColor: ThemeData.dark().colorScheme.onSurface,
          unselectedItemColor: ThemeData.dark().colorScheme.onSurface,
        ),
      ),

      // 現在のモードに応じて theme または darkTheme を適用
      themeMode: _mode,

      // 最初に表示する画面は HomePage
      home: HomePage(
        title: 'NEWS EXPRESS', // アプリバーやヘッダーで利用可能
        isDarkMode: _mode == ThemeMode.dark, // スイッチの初期状態
        onThemeToggle:
            _toggleTheme, // HomePage から呼び出される関数。スイッチ操作時に渡される真偽値を元に _toggleTheme が実行される          // スイッチ操作時のコールバック
      ),
    );
  }
}
