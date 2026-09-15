import 'package:flutter/material.dart';
import 'profile/auth_screen.dart';

void main() {
  runApp(const KayaWalletApp());
}

class KayaWalletApp extends StatelessWidget {
  const KayaWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KayaWallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF8F2),
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(goals: []),
    );
  }
}