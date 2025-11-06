import 'package:flutter/material.dart';
import 'package:estante/src/shared/constants/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoToAccessPage extends StatelessWidget {
  const GoToAccessPage({super.key});

  void _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exemplo de uma imagem para o slide
          Image.asset('assets/images/onboarding_four.png', height: 200),
          const SizedBox(height: 32),
          Text(
            'Pronto! Vamos começar a ler?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Sua jornada pela Livraria do Duque começa agora.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _completeOnboarding(context),
            child: const Text('Ir para o Acesso'),
          ),
        ],
      ),
    );
  }
}