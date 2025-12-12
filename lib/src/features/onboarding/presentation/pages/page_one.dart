import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.castle, size: 100, color: AppTheme.gold),
          const SizedBox(height: 30),
          Text(
            'Bem-vindo(a) à Livraria do Duque',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            'Aqui catalogamos seus volumes mais preciosos. Antes de começar, por favor, aceite os termos do Reino.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}