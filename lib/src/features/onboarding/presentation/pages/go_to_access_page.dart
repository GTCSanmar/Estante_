import 'package:flutter/material.dart';
import 'package:estante/src/app_config.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart'; 
import '../../../../../../main.dart'; 

class GoToAccessPage extends StatelessWidget {
  const GoToAccessPage({super.key});

  void _completeOnboarding(BuildContext context) async {
    await prefsService.setOnboardingCompleted(true); 

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_add_check, size: 100, color: AppTheme.gold),
          const SizedBox(height: 30),
          Text(
            'Seu Selo Real de Acesso Foi Concedido',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _completeOnboarding(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('ACESSAR MINHA ESTANTE'),
          ),
        ],
      ),
    );
  }
}