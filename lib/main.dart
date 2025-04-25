import 'package:flutter/material.dart'; // flutter標準パッケージ
import 'package:news_app_202504/providers/articles_provider.dart'; // プロバイダーの状態管理クラスを使うためのパッケージ
import 'package:provider/provider.dart'; // 自作の状態管理クラスパッケージ
import 'pages/home_page.dart'; // ホーム画面へ繋ぐために使う
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Flutter アプリ側で .env を読み込む
import 'package:news_app_202504/services/api_service.dart'; // NewsAPI 呼び出しロジックのクラスを定義

// main() 関数を async にして、アプリ起動前に環境変数を読み込むように変更（環境変数としてAPIキーを安全に扱うため）
Future<void> main() async {
  // ① .env の読み込み
  await dotenv.load(fileName: '.env');
  runApp(
    ChangeNotifierProvider(
      // ArticlesProvider をアプリ全体で提供し、notifyListeners() でUI更新を可能にする
      create: (_) => ArticlesProvider(),
      child: const MyApp(), // アプリを起動
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
        scaffoldBackgroundColor: Colors.white, // ライトモード時の背景は白
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
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 3, 72, 179), // プライマリーカラー
          foregroundColor: ColorScheme.light().onPrimary, // タイトル文字色
          elevation: 2,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 3, 72, 179),
          selectedItemColor: Colors.white, // 選択時アイコン色
          unselectedItemColor: Colors.white, // 非選択アイコン色
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
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.dark().surface,
          foregroundColor: ColorScheme.dark().onSurface,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ColorScheme.dark().surface,
          selectedItemColor: ColorScheme.dark().onSurface,
          unselectedItemColor: ColorScheme.dark().onSurface,
        ),
      ),
      themeMode: _mode, // _mode に応じて theme ⇄ darkTheme を切り替える。アプリ全体が再描画される
      home: HomePage(
        // HomePage に今のモードと切り替え関数を渡す
        title: 'NEWS EXPRESS',
        isDarkMode: _mode == ThemeMode.dark,
        onThemeToggle: _toggleTheme, // テーマ切り替え用のコールバックを渡す
      ),
    );
  }
}
