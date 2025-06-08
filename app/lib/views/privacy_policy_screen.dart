import 'package:app/models/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_back_button.dart';
import '../widgets/page_header.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  final String _privacyPolicyText = '''
Politique de Confidentialité

Votre vie privée est notre priorité. Cette application collecte uniquement les informations nécessaires à son bon fonctionnement. Voici les données que nous recueillons :

- Adresse e-mail : utilisée pour l’authentification et la gestion du compte utilisateur.
- Mot de passe : stocké de manière sécurisée et chiffrée.
- Contenu personnel (rêves) : les rêves que vous rédigez sont strictement personnels et ne sont jamais partagés avec d’autres utilisateurs ou des tiers.

Nous nous engageons à :
- Ne jamais vendre, louer ou partager vos données à des fins commerciales.
- Ne jamais permettre l’accès à vos rêves à quiconque sauf vous-même.
- Utiliser des mesures de sécurité avancées pour protéger toutes les informations.

En utilisant cette application, vous acceptez cette politique. Vous restez à tout moment propriétaire de vos données.

Merci pour votre confiance.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBackButton(),

      body: Column(
        children: [
          PageHeader(
            title: "Politique de confidentialité",
          ),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _privacyPolicyText,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
