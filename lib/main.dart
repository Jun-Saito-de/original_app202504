import 'package:flutter/material.dart';
import 'pages/home_page.dart';

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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomePage(title: 'NEWS EXPRESS'),
    );
  }
}
