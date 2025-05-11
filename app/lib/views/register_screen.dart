import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../../widgets/custom_pass_strength.dart';
import '../widgets/password_criteria_item.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RegisterViewModel viewModel = RegisterViewModel();

  bool isLoading = false;

  final passNotifier = ValueNotifier<CustomPassStrength?>(null);

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => setState(() {}));
  }


  void _handleRegister() async {
    setState(() => isLoading = true);

    final success = await viewModel.register(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "🎉 Inscription réussie"
            : "❌ Erreur d'inscription"),
      ),
    );

    if (success) {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Créer un compte",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 32),
                _buildTextField("Email", emailController, false),

                if(emailController.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!viewModel.isEmailValid(emailController.text))
                        const Text("email incorrect")
                    ],
                    ),
                

                const SizedBox(height: 16),
                //_buildTextField("Mot de passe", passwordController, true),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onChanged: (value) {
                    passNotifier.value = CustomPassStrength.calculate(text: value);
                  },
                ),
                const SizedBox(height: 12),

                if (passwordController.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PasswordCriteriaItem(
                        isValid: viewModel.isLengthValid(passwordController.text),
                        text: 'At least 15 characters',
                      ),
                      PasswordCriteriaItem(
                        isValid: viewModel.hasAtLeastNDistinctLowercase(passwordController.text, 5),
                        text: 'At least 5 different lowercase letters',
                      ),
                      PasswordCriteriaItem(
                        isValid: viewModel.hasAtLeastNDistinctUppercase(passwordController.text, 2),
                        text: 'At least 2 different uppercase letters',
                      ),
                      PasswordCriteriaItem(
                        isValid: viewModel.hasDigits(passwordController.text),
                        text: 'At least 2 digits',
                      ),
                      PasswordCriteriaItem(
                        isValid: viewModel.hasSpecialChars(passwordController.text),
                        text: 'At least 2 special characters',
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                PasswordStrengthChecker(
                  strength: passNotifier,
                ),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text("J'ai déjà un compte ? Connexion"),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "S'inscrire",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: obscure ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
