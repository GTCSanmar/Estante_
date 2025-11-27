
import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart'; 
import 'dart:async';
import '../../../../../../main.dart'; 

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState() {
    super.initState();
    _startNavigationSequence();
  }

  void _startNavigationSequence() async {
    final minTime = Future.delayed(const Duration(milliseconds: 1500)); 

    
    await initializeDependencies();

    await minTime;
    
    final onboardingCompleted = prefsService.getOnboardingCompleted;

    if (mounted) {
      if (onboardingCompleted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 150, color: AppTheme.gold),
            SizedBox(height: 20),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold)),
            SizedBox(height: 20),
            Text('Aguardando o Selo Real...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}