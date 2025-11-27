
import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart';

import 'package:estante/src/features/home/presentation/pages/home_page.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/authors_page.dart'; 

import 'package:estante/src/features/onboarding/presentation/pages/splash_page.dart';
import 'package:estante/src/features/onboarding/presentation/pages/onboard_page.dart';
import 'package:estante/src/features/onboarding/presentation/pages/policy_viewer_page.dart'; 

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    const String dummyPolicyContent = "## Política de Privacidade do Reino (Versão 1.0) Por ordem do Duque, todos os leitores devem aderir às seguintes Leis da Livraria. Este documento estabelece que seus dados (apenas preferências de leitura e estatísticas anônimas) serão usados unicamente para melhorar sua experiência na estante. Seus dados jamais serão vendidos a reinos vizinhos ou comerciantes. A aceitação deste pergaminho é o selo de confiança entre o Leitor e o Duque. ### 1. Coleta de Dados Coletamos apenas o ID do livro, a página atual e o status de leitura. Nenhuma informação pessoal identificável (nome, localização, etc.) é armazenada sem o seu consentimento explícito. ### 2. Uso da Informação Os dados são utilizados para: a) Oferecer recomendações de leitura; b) Melhorar a funcionalidade da estante; c) Garantir a integridade dos volumes. ### 3. Direitos do Leitor (LGPD) Você tem o direito de revogar seu consentimento e solicitar a exclusão de seus dados a qualquer momento, através do menu 'Configurações' na Estante principal. --- [FIM DO PERGAMINHO 1] ---";
    const String dummyTermsContent = "## Termos de Uso e Manutenção da Estante Os Termos de Uso do Reino proíbem a cópia não autorizada dos manuscritos e o uso de magia negra para alterar o conteúdo da biblioteca. Qualquer violação resultará na suspensão imediata da sua licença de leitura. ### 1. Propriedade Intelectual Todo o conteúdo, design e código-fonte pertencem ao Duque e são protegidos pelas leis do Reino. A reprodução sem permissão é estritamente proibida. ### 2. Conduta do Usuário É proibido o uso de linguagem imprópria, ameaças ou qualquer conduta que perturbe a paz e a serenidade da Livraria. ### 3. Resolução de Disputas Qualquer disputa será resolvida pelo Conselho de Sábios da Corte do Duque, cuja decisão é final e inapelável. ### 4. Aceitação Ao usar esta aplicação, você concorda com todas as cláusulas do Pergaminho. Para marcar como lido, você deve rolar até o final. --- [FIM DO PERGAMINHO 2] ---";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livraria do Duque',
      theme: AppTheme.theme,
      
      initialRoute: AppRoutes.splash, 
      
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.onboarding: (context) => const OnboardPage(), 
        AppRoutes.home: (context) => const HomePage(), 
        
        AppRoutes.authors: (context) => const AuthorsPage(), 

        AppRoutes.policyViewer: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return PolicyViewerPage(
            title: args['title']!,
            policyKey: args['policyKey']!,
            policyContent: args['policyKey'] == 'privacy' ? dummyPolicyContent : dummyTermsContent,
          );
        },
      },
    );
  }
}