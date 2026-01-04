import 'package:flutter/material.dart';
import 'package:music_player/views/register-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFF1DB954),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1DB954),
          secondary: Color(0xFF1DB954),
          surface: Colors.white,
          onPrimary: Colors.black,
          onSurface: Colors.black,
        ),
      ),
      home: RegisterPage(),
    );
  }
}
