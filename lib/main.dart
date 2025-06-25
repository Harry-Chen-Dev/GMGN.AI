import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GMGN Crypto',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9CFF2A),
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}