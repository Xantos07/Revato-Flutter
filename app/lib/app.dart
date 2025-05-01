import 'package:flutter/material.dart';
import 'widgets/SplashScreen.dart';
import '../views/register_screen.dart';
import '../views/login_screen.dart';
import 'views/home_scaffold.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScaffold(),
      },
    );
  }
}
