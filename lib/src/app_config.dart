import 'package:flutter/material.dart';
import 'package:estante/src/features/onboarding/splash_page.dart';
import 'package:estante/src/shared/constants/app_routes.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/features/onboarding/onboard_page.dart';

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.onboarding: (context) => const OnboardingPage(),
        AppRoutes.home: (context) => const Scaffold(body: Center(child: Text('Tela Principal'))),
      },
    );
  }
}