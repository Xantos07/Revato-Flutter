import 'package:flutter/material.dart';
import 'creation_reve_screen.dart';

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
      home: const CreationReveScreen(),
    );
  }
}
