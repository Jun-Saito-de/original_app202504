import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _checked = false;

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
                        child: Switch(value: _checked, onChanged: _onToggle),
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
                    onPressed: () {},
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

  void _onToggle(bool? value) {
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
