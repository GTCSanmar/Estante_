import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.format_list_bulleted, size: 100, color: AppTheme.gold),
          const SizedBox(height: 30),
          Text(
            'Como Funciona a Catalogação',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            'Cadastre livros, defina o autor e marque o status de leitura para organizar sua estante virtual.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}