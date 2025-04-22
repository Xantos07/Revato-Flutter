import 'package:flutter/material.dart';
import 'redaction_screen.dart';
import 'home_scaffold.dart';

class CarrouselReveApp extends StatelessWidget {
  const CarrouselReveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Création de Rêve',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFE4DAED),
      ),
      home: const HomeScaffold(),
    );
  }
}
