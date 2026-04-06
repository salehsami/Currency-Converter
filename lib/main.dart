// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Forces status bar icons to be light (white) on the dark app bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globe Max',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF387AAE),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        // Clean flat AppBar — the semi-circle shape caused clipping issues
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0C243C),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: kToolbarHeight,
        ),
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}
