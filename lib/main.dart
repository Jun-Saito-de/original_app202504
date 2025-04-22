import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'news express',
      theme: ThemeData(
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
      ),
      home: const MyHomePage(title: 'NEWS EXPRESS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'NEWS EXPRESS',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
            fontFamily: "LexendDeca",
          ),
        ),
      ),
      body: Center(
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
                        child: Switch(value: _checked, onChanged: checkChanged),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.nightlight_round),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkChanged(bool? value) {
    setState(() {
      _checked = value!;
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
