// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

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
            // Avatar + nom
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.deepPurple.shade200,
              backgroundImage: AssetImage('assets/profil.png'),
              //child: Icon(Icons.person, size: 64, color: Colors.white),
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

            // Liste de boutons
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text("Politique de Confidentialité"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: naviguer vers la page PrivacyPolicyScreen
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.rule),
                    title: const Text("Conditions d’utilisation"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: naviguer vers les T&C
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Paramètres"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: naviguer vers SettingsScreen
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Déconnexion",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      // TODO: déclencher le logout
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
