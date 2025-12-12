import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart';

// Importa todas as páginas necessárias
import 'package:estante/src/features/home/presentation/pages/home_page.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/authors_page.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/splash_page.dart';
import 'package:estante/src/features/onboarding/presentation/pages/onboard_page.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/policy_viewer_page.dart'; 

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    // Conteúdo Dummy para as Políticas (para evitar erros de sintaxe)
    const String dummyPolicyContent = "Este é o conteúdo longo da Política de Privacidade. O Duque exige total transparência, por isso, este pergaminho tem mais de 500 palavras de sabedoria real. Role até o final para o Selo.";
    const String dummyTermsContent = "Este é o conteúdo longo dos Termos de Uso. Esta é a Lei do Reino. Para garantir que sua licença de leitura seja válida, você deve aceitar integralmente as regras do Conselho de Sábios.";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livraria do Duque',
      theme: AppTheme.theme, 
      
      // CRÍTICO: Usamos initialRoute para forçar o roteamento.
      initialRoute: AppRoutes.splash,
      
      // Mapeamento das rotas (Rotas Simples e a Rota com Argumentos)
      routes: {
        // Rotas sem Argumentos
        AppRoutes.splash: (context) => const SplashPage(), 
        AppRoutes.onboarding: (context) => const OnboardPage(), 
        AppRoutes.home: (context) => const HomePage(), // CRÍTICO: /home existe
        AppRoutes.authors: (context) => const AuthorsPage(), 

        // ROTA CRÍTICA: Visualizador de Políticas (RF-3 - Rota com argumentos)
        AppRoutes.policyViewer: (context) {
          final settings = ModalRoute.of(context)?.settings;
          final args = settings?.arguments as Map<String, String>?;

          final title = args?['title'] ?? 'Erro de Título';
          final policyKey = args?['policyKey'] ?? 'privacy';
          
          final content = policyKey == 'privacy' 
            ? dummyPolicyContent * 5 
            : dummyTermsContent * 5;

          return PolicyViewerPage(
            title: title,
            policyKey: policyKey,
            policyContent: content,
          );
        },
      },
    );
  }
}