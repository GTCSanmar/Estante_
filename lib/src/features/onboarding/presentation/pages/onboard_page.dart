import 'package:flutter/material.dart';
import 'package:estante/src/app_config.dart';
// CRÍTICO: CORRIGIDO o caminho de importação para a página de Consentimento
import 'package:estante/src/features/onboarding/presentation/pages/consent_page.dart'; 
import 'package:estante/src/shared/theme/app_theme.dart';

// CRÍTICO: CORRIGIDO os nomes dos arquivos de Onboarding
import 'package:estante/src/features/onboarding/presentation/pages/page_one.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/page_two.dart'; 
import 'package:estante/src/features/onboarding/presentation/pages/go_to_access_page.dart'; 


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _canFinalize = false; // Estado do aceite (LGPD)
  
  // Lista de páginas do fluxo (4 páginas no total)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    _pages = [
      const PageOne(), 
      const PageTwo(), 
      // CRÍTICO: Passa o callback de estado para o ConsentPage
      ConsentPage(onConsentChanged: (canFinalize) { 
        setState(() {
          _canFinalize = canFinalize;
        });
      }),
      const GoToAccessPage(),
    ];
    
    // CRÍTICO: Adia a adição do Listener para depois do primeiro frame (PostFrameCallback)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.addListener(() {
        // O setState é seguro aqui, pois a UI já está construída
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
      });
    });
  }

  // --- Métodos de Navegação (Omitidos por brevidade) ---
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeIn,
      );
    }
  }
  
  void _handleConsentFinalization() {
    if (_canFinalize) {
       _nextPage(); 
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    final isConsentPage = _currentPage == 2;
    
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: _pages,
          ),
          
          // --- Controles de Navegação ---
          if (!isLastPage) 
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                // CRÍTICO: Padding ajustado para mover o botão mais para cima (horizontal 24, vertical 10)
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 40.0), 
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.darkGreen.withOpacity(0.9), 
                    border: const Border(top: BorderSide(color: AppTheme.gold, width: 0.5)),
                    borderRadius: BorderRadius.circular(12), // Adicionado para melhor UX
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão VOLTAR
                      if (_currentPage > 0) 
                        TextButton(
                          onPressed: _previousPage,
                          child: const Text('VOLTAR', style: TextStyle(color: AppTheme.gold)),
                        )
                      else
                        const SizedBox(width: 80), 
                      
                      // Indicador de Dots 
                      Row(
                        children: List.generate(_pages.length - 1, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: _currentPage == index 
                                  ? AppTheme.gold 
                                  : AppTheme.darkGreen,
                            ),
                          );
                        }),
                      ),
                      
                      // Botão AVANÇAR / FINALIZAR
                      if (isConsentPage)
                         ElevatedButton(
                           // CRÍTICO: O _canFinalize agora é controlado pela ConsentPage
                           onPressed: _canFinalize ? _handleConsentFinalization : null, 
                           style: ElevatedButton.styleFrom(
                             backgroundColor: _canFinalize ? AppTheme.gold : AppTheme.darkGreen.withOpacity(0.5),
                           ),
                           child: const Text('FINALIZAR'),
                         )
                      else 
                         ElevatedButton(
                           onPressed: _nextPage,
                           child: const Text('AVANÇAR'),
                         )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}