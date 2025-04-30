import 'package:flutter/material.dart';
import '../widgets/profile_option_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.deepPurple.shade200,
              backgroundImage: const AssetImage('assets/profil.png'),
            ),
            const SizedBox(height: 12),
            const Text(
              "Jean Dupont",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "jean.dupont@example.com",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Menu options
            Expanded(
              child: ListView(
                children: [
                  ProfileOptionTile(
                    icon: Icons.privacy_tip,
                    title: "Politique de Confidentialité",
                    onTap: () {
                      // TODO
                    },
                  ),
                  ProfileOptionTile(
                    icon: Icons.rule,
                    title: "Conditions d’utilisation",
                    onTap: () {
                      // TODO
                    },
                  ),
                  ProfileOptionTile(
                    icon: Icons.settings,
                    title: "Paramètres",
                    onTap: () {
                      // TODO
                    },
                  ),
                  ProfileOptionTile(
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    title: "Déconnexion",
                    onTap: () {
                      // TODO
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
