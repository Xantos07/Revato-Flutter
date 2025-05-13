import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const Text(
                  "Modifier vos informations",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: inputDecoration.copyWith(labelText: 'Adresse e-mail'),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: inputDecoration.copyWith(labelText: 'Mot de passe'),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Préférences",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SwitchListTile(
                  value: true,
                  onChanged: (value) {},
                  title: const Text("Recevoir des notifications"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fonction non disponible pour le moment")),
                    );
                  },
                  child: const Text("Sauvegarder"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
