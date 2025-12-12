import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart'; 
import 'dart:async';
// Importa widgets alvo diretamente (para não usar rotas nomeadas)
import '../../../../../../main.dart'; // Acesso à função initDependencies()

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  static const int _minimumSplashDurationMs = 2000; // 2.0 segundos

  @override
  void initState() {
    super.initState();
    // Inicia a navegação APÓS a inicialização
    _startAppInitialization();
  }

  // A função agora navega (pushReplacementNamed)
  Future<void> _startAppInitialization() async {
    // 1. Marca o início da execução
    final startTime = DateTime.now();

    // 2. Chama a inicialização das dependências (CRÍTICO: Acontece aqui)
    try {
      await initDependencies(); 
    } catch (e) {
      // Se houver erro, exibe um alerta e trava (melhor que tela branca)
      print("ERRO DE DEPENDÊNCIA: $e");
      // Poderíamos mostrar um AlertDialog aqui, mas simplificamos para o log.
    }
    
    // 3. Leitura e decisão de rota
    final onboardingCompleted = prefsService.getOnboardingCompleted;
    
    // 4. Calcula o tempo restante para cumprir a duração mínima
    final endTime = DateTime.now();
    final timeElapsedMs = endTime.difference(startTime).inMilliseconds;
    final timeToWaitMs = _minimumSplashDurationMs - timeElapsedMs;
    
    // 5. Aguarda o tempo restante para garantir os 2 segundos totais
    if (timeToWaitMs > 0) {
      await Future.delayed(Duration(milliseconds: timeToWaitMs));
    }
    
    // 6. Navega para a rota alvo
    if (mounted) {
      final targetRoute = onboardingCompleted ? AppRoutes.home : AppRoutes.onboarding;
      // Navega (O Navigator deve estar disponível AGORA)
      Navigator.pushReplacementNamed(context, targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retorna a tela de carregamento visual
    return const Scaffold(
      backgroundColor: AppTheme.darkGreen,
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