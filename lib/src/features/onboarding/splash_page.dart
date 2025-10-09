import 'package:flutter/material.dart';
import 'package:estante/src/shared/constants/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    // Use um atraso para que a tela de splash seja visível por um tempo
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        if (onboardingCompleted) {
          // Se o onboarding já foi visto, navega direto para a tela principal
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          // Se não, navega para o onboarding
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Livraria-Logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            // Adicione um texto para feedback
            const Text('Carregando...'),
          ],
        ),
      ),
    );
  }
}