import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart';

// Importa todas as páginas necessárias
import 'package:estante/src/features/home/presentation/pages/home_page.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/authors_page.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/splash_page.dart';
import 'package:estante/src/features/onboarding/presentation/pages/onboard_page.dart'; // Importa a classe OnboardingPage
import 'package:estante/src/features/onboarding/presentation/pages/policy_viewer_page.dart'; 

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});
  
  // Função central para gerar rotas (solução mais robusta para argumentos)
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    // Conteúdo Dummy expandido para garantir a rolagem
    const String dummyPolicyContent = "Este é o conteúdo longo da Política de Privacidade. O Duque exige total transparência, por isso, este pergaminho tem mais de 500 palavras de sabedoria real. Role até o final para o Selo. ";
    const String dummyTermsContent = "Este é o conteúdo longo dos Termos de Uso. Esta é a Lei do Reino. Para garantir que sua licença de leitura seja válida, você deve aceitar integralmente as regras do Conselho de Sábios.";

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
        
      case AppRoutes.onboarding:
        // CRÍTICO: Correção do nome da classe de OnboardPage para OnboardingPage
        return MaterialPageRoute(builder: (_) => const OnboardingPage()); 
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.authors:
        return MaterialPageRoute(builder: (_) => const AuthorsPage());

      // ROTA CRÍTICA: Visualizador de Políticas (A rota que falha ao abrir)
      case AppRoutes.policyViewer:
        // A checagem de argumentos é feita de forma mais segura aqui (settings.arguments)
        final args = settings.arguments as Map<String, String>?;
        
        // Retorna um MaterialPageRoute com o widget alvo
        if (args != null) {
            final title = args['title'] ?? 'Erro de Título';
            final policyKey = args['policyKey'] ?? 'privacy';
            
            final content = policyKey == 'privacy' 
              ? dummyPolicyContent * 5 
              : dummyTermsContent * 5;

            return MaterialPageRoute(
              builder: (_) => PolicyViewerPage(
                title: title,
                policyKey: policyKey,
                policyContent: content,
              ),
            );
        }
        // Se a rota for chamada sem argumentos, retorna uma tela de erro
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Erro: Argumentos da Política faltando"))));

      default:
        // Retorna um fallback (tela de erro) se a rota for inválida
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Erro: Rota não encontrada. Use o DevTools para inspecionar."))));
    }
  }


  @override
  Widget build(BuildContext context) {
    // Conteúdo Dummy para as Políticas (Mantemos aqui as consts para a função _onGenerateRoute)
    const String dummyPolicyContent = "Este é o conteúdo longo da Política de Privacidade. O Duque exige total transparência, por isso, este pergaminho tem mais de 500 palavras de sabedoria real. Role até o final para o Selo.";
    const String dummyTermsContent = "Este é o conteúdo longo dos Termos de Uso. Esta é a Lei do Reino. Para garantir que sua licença de leitura seja válida, você deve aceitar integralmente as regras do Conselho de Sábios.";


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livraria do Duque',
      theme: AppTheme.theme, 
      
      initialRoute: AppRoutes.splash, 
      
      onGenerateRoute: _onGenerateRoute,
    );
  }
}