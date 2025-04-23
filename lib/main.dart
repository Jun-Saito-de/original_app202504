import 'package:flutter/material.dart';
import 'package:news_app_202504/providers/articles_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Flutter アプリ側で .env を読み込む

// main() 関数を async にして、アプリ起動前に環境変数を読み込むように変更
Future<void> main() async {
  // ① .env の読み込み
  await dotenv.load(fileName: '.env');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ArticlesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // テーマモードという状態（ライト／ダーク）を保持し、切り替えられるようにするため、StatefulWidget に変更
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // _mode という ThemeMode を用意＆切り替え関数を作る
  // themeMode に渡す値を保持し、スイッチ操作で切り替える
  ThemeMode _mode = ThemeMode.light; // 初期はライトモード

  // Switch の操作で onChanged が呼ばれ、isDark に状態（true/false）が渡る
  void _toggleTheme(bool isDark) {
    // _toggleTheme(isDark) が呼ばれ、その isDark を元に _mode を更新
    setState(() {
      // setState で再描画 → MaterialApp の themeMode に新しい _mode が反映
      // _mode とは現在のモード（ThemeMode.light／ThemeMode.dark）のこと
      _mode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'news express',
      // ライト用カラー・ボタンスタイル
      theme: ThemeData.light().copyWith(
        // copyWith で双方のカスタムカラー＆ボタンを設定
        colorScheme: ColorScheme(
          primary: Color.fromARGB(255, 3, 72, 179),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 70, 165, 240),
          onSecondary: Color.fromARGB(255, 30, 30, 30),
          brightness: Brightness.light,
          error: Colors.red,
          onError: Colors.white,
          onSurface: Color.fromARGB(255, 30, 30, 30),
          surface: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 230, 230, 230),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // ダーク用カラー・ボタンスタイル
      darkTheme: ThemeData.dark().copyWith(
        // copyWith で双方のカスタムカラー＆ボタンを設定
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(255, 245, 245, 245),
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 245, 245, 245),
          onSecondary: Color.fromARGB(255, 30, 30, 30),
          brightness: Brightness.light,
          error: Colors.red,
          onError: Colors.white,
          onSurface: Colors.white,
          surface: Colors.grey.shade900,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 245, 245, 245),
            foregroundColor:
                Colors.black, // ElevatedButton の文字色は foregroundColor で設定
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      themeMode: _mode, // _mode に応じて theme ⇄ darkTheme を切り替える。アプリ全体が再描画される
      home: HomePage(
        // HomePage に今のモードと切り替え関数を渡す
        title: 'NEWS EXPRESS',
        isDarkMode: _mode == ThemeMode.dark,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
