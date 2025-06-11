import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profil_view_model.dart';
import '../../viewmodels/dream_list_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _preloadData();
  }

  Future<void> _preloadData() async {
    try {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      final dreamListVM = Provider.of<DreamListViewModel>(context, listen: false);

      await profileVM.loadUser();
      await dreamListVM.loadInitialDreams(); // Crée cette méthode dans DreamListViewModel

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print("Erreur de préchargement : $e");
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
