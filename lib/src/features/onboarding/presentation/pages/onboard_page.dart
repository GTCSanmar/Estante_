import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/widgets/dots_indicator.dart'; 
import 'package:estante/src/shared/constants/app_routes.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import '../../../../../main.dart'; // Acesso ao prefsService
import 'consent_page.dart'; 
import 'page_one.dart'; 
import 'page_two.dart'; 
import 'go_to_access_page.dart'; 

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _canFinalize = false; 
  
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    _pages = [
      const PageOne(), 
      const PageTwo(), 
      ConsentPage(onConsentChanged: (canFinalize) {
        // CORREÇÃO CRÍTICA: Envolve o setState em addPostFrameCallback.
        // Isso garante que a reconstrução do OnboardPage ocorra APÓS o build inicial
        // (eliminando o erro 'setState() called during build').
        WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _canFinalize = canFinalize;
            });
        });
      }),
      const GoToAccessPage(),
    ];
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeIn,
      );
    }
  }
  
  // CRÍTICO: Novo método para finalizar o Onboarding (usado no botão Finalizar na página 2)
  void _handleConsentFinalization() {
    if (_canFinalize) {
       // O Opt-in já foi salvo na ConsentPage, apenas avançamos
       _nextPage(); // Vai para a GoToAccessPage (último passo)
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
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.darkGreen.withOpacity(0.9), 
                    border: const Border(top: BorderSide(color: AppTheme.gold, width: 0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão VOLTAR (Visível em todas as páginas antes da última)
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
                           onPressed: _canFinalize ? _handleConsentFinalization : null, // Chama a função de finalização
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