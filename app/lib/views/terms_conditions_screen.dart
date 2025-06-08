import 'package:flutter/material.dart';

import '../models/app_colors.dart';
import '../widgets/bottom_back_button.dart';
import '../widgets/page_header.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  final String _termsText = '''
Conditions Générales d’Utilisation

En utilisant cette application, vous acceptez les conditions suivantes :

1. Utilisation personnelle uniquement :
L’application est destinée à un usage strictement personnel. Vous êtes responsable du contenu que vous saisissez, notamment les rêves que vous écrivez.

2. Sécurité du compte :
Vous êtes responsable de la sécurité de vos identifiants. Ne partagez pas votre mot de passe. Si vous suspectez une activité suspecte, veuillez nous contacter immédiatement.

3. Confidentialité des données :
Toutes les informations saisies (email, mots de passe, rêves) restent strictement privées. Aucune donnée ne sera partagée avec des tiers, sauf obligation légale.

4. Respect de la plateforme :
L’utilisation abusive de l’application, comme l’injection de contenu illégal, offensant ou non sollicité, entraînera la suppression du compte.

5. Modifications des conditions :
Ces conditions peuvent évoluer. Toute modification sera notifiée dans l’application.

Merci d’utiliser notre service en toute confiance.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBackButton(),

      body: Column(
        children: [
          PageHeader(
            title: "Conditions d'utilisation",
          ),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _termsText,
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
