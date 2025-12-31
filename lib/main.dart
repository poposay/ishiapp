import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const IshikoroApp());
}

class IshikoroApp extends StatelessWidget {
  const IshikoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'いしコロ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansJP',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
  //test
}