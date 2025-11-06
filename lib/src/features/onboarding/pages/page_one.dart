import 'package:flutter/material.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Envolva a imagem em um Expanded para que ela ocupe o espaço disponível
          // mas não ultrapasse os limites. Ou use um SizedBox para altura fixa.
          Expanded( // <-- Adicione Expanded aqui
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/onboarding_one.png',
                fit: BoxFit.contain, // <-- Mude para BoxFit.contain ou BoxFit.fitHeight
                                    // BoxFit.contain ajusta a imagem dentro do espaço
                                    // mantendo a proporção.
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Organize suas leituras',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Crie estantes virtuais, categorize por gênero e marque seus livros favoritos.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}