import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profil_view_model.dart';
import '../viewmodels/dream_list_viewmodel.dart';
import 'widgets/SplashScreen.dart';
import '../views/register_screen.dart';
import '../views/login_screen.dart';
import 'views/home_scaffold.dart';

class CarrouselReveApp extends StatelessWidget {
  const CarrouselReveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => DreamListViewModel()),
      ],
      child: MaterialApp(
        title: 'Création de Rêve',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => const HomeScaffold(),
        },
      ),
    );
  }
}
