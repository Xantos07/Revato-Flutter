import 'package:app/views/privacy_policy_screen.dart';
import 'package:app/views/settings_screen.dart';
import 'package:app/views/terms_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profil_view_model.dart';
import '../widgets/profile_option_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ProfileViewModel();
        vm.loadUser();
        return vm;
      },
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final user = viewModel.user;
          if (user == null) {
            return const Scaffold(body: Center(child: Text("Erreur de chargement.")));
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Mon Profil"), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/profil.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(user.email, style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView(
                      children: [
                        ProfileOptionTile(icon: Icons.privacy_tip, title: "Politique de Confidentialité",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                              );
                            }),
                        ProfileOptionTile(icon: Icons.rule, title: "Conditions d’utilisation",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TermsConditionsScreen())
                              );
                            }),
                        ProfileOptionTile(icon: Icons.settings, title: "Paramètres",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SettingsScreen())
                              );
                            }),
                        ProfileOptionTile(
                          icon: Icons.logout,
                          iconColor: Colors.red,
                          textColor: Colors.red,
                          title: "Déconnexion",
                          onTap: () => viewModel.logout(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
