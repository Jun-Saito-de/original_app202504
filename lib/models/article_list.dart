// API のレスポンス JSON を見て、画面で本当に必要になる項目（タイトル、企業名、URL など）だけをピックアップして
// Dart のオブジェクト（NewsData）に変換するモデルクラス

// [APIのJSONと同じ名前を変数名に使う]
// クラスのメンバー変数を定義
// final で書くことで「読み取り専用のフィールド」として安全に使用
class NewsData {
  // ── ニュース記事データの構造を定義する雛形（設計図）──
  // これらの項目を必ず持ったインスタンスを生成します
  // final String id;
  final String title;
  final String urlToImage;
  final String url;

  // ── コンストラクタ ──
  // required で「必ず値を渡す」ことを保証します
  NewsData({
    // required this.id,
    required this.title,
    required this.urlToImage,
    required this.url,
  });

  // fromJson Factory コンストラクタを実装
  // 外部（API）の JSON データを受け取り、
  // NewsData 型のインスタンスにマッピングして返します
  factory NewsData.fromJson(Map<String, dynamic> json) {
    // ここで JSON のキーとクラスのフィールドを紐づけ、文字列→String、日時なら文字列→DateTime.parse といった変換
    return NewsData(
      // id:json['source']['id'] as String? ??
      //     '', // as String? ?? '' で null 安全に空文字フォールバック
      title: json['title'] as String,
      urlToImage:
          json['urlToImage'] as String? ??
          '', // urlToImage キーの値を String に。null のときは空文字
      url: json['url'] as String,
    );
  }
}
