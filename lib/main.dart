import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globe Max Currency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF162836),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0C243C),
          shape: SemiCircleBottomShape(),
          elevation: 5,
          toolbarHeight: kToolbarHeight + 40,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
