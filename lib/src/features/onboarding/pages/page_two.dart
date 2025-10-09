import 'package:flutter/material.dart';

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded( // <-- Adicione Expanded aqui
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/onboarding_two.png', // Verifique se o nome do arquivo está correto
                fit: BoxFit.contain, // <-- Mude para BoxFit.contain
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Acompanhe seu progresso',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Veja quantas páginas você já leu e defina metas para alcançar seus objetivos de leitura.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}