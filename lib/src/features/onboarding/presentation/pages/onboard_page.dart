import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/widgets/dots_indicator.dart'; 
import 'package:estante/src/shared/constants/app_routes.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import '../../../../../main.dart'; // Acesso ao prefsService
import 'consent_page.dart'; 
import 'page_one.dart'; // Mantemos para referência
import 'page_two.dart'; // Mantemos para referência
import 'go_to_access_page.dart'; // Mantemos para referência

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _canFinalize = false; 
  
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
        _pageController.addListener(_onPageChange);
    
  
  }

 
  Widget _buildOnboardStep(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      color: AppTheme.darkGreen,
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppTheme.gold),
          const SizedBox(height: 30),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  List<Widget> get _getPages => [
    _buildOnboardStep(
      context, 
      'Bem-vindo ao Tesouro do Duque', 
      'Aqui estão os passos iniciais para acessar sua estante. Deslize para começar.', 
      Icons.menu_book,
    ),
    _buildOnboardStep(
      context,
      'Sua Biblioteca Privada', 
      'Somente o Duque e você têm acesso total. Seus dados de leitura permanecem seguros.', 
      Icons.lock_rounded,
    ),
    ConsentPage(onConsentChanged: _handleConsentChange),
    
    const GoToAccessPage(),
  ];

  void _handleConsentChange(bool canFinalize) {
    // Usamos addPostFrameCallback AQUI para o setState ser no próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_canFinalize != canFinalize) {
        setState(() {
          _canFinalize = canFinalize;
        });
      }
    });
  }

  void _onPageChange() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
      
      if (_currentPage == 2) { // Índice 2 é a ConsentPage
        // Não acessamos _pages diretamente, mas sim o índice
        // Força a reavaliação ao entrar na página de Consentimento
        // O ConsentPage agora cuida de sua própria checagem inicial de forma assíncrona/segura
      } else {
        _canFinalize = false; 
      }
    });
  }

  void _skipOnboarding() async {
    final privacyRead = prefsService.getPrivacyPolicyRead;
    final termsRead = prefsService.getTermsRead;
    
    if (!privacyRead || !termsRead) {
       _showCustomAlert(
        'Requisito Legal', 
        'Para prosseguir, você deve ler a Política de Privacidade e os Termos de Uso. Por favor, navegue até a última página.',
        Icons.warning_rounded,
       );
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      return;
    }
    
    await prefsService.setOnboardingCompleted(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void _finalizeOnboarding() async {
    if (_canFinalize) {
      await prefsService.setOnboardingCompleted(true);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  void _showCustomAlert(String title, String message, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGreen,
        title: Row(
          children: [
            Icon(icon, color: AppTheme.gold),
            const SizedBox(width: 10),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChange);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _getPages.length - 1;
    final isConsentPage = _currentPage == 2;

    return Scaffold(
      backgroundColor: AppTheme.darkGreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _getPages, 
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppTheme.darkGreen.withOpacity(0.9),
                border: const Border(top: BorderSide(color: AppTheme.gold, width: 0.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOpacity(
                    opacity: isLastPage ? 0.0 : 1.0, 
                    duration: const Duration(milliseconds: 300),
                    child: DotsIndicator( 
                      dotsCount: _getPages.length,
                      position: _currentPage,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0 && !isLastPage)
                        TextButton(
                          onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          ),
                          child: const Text('VOLTAR', style: TextStyle(color: AppTheme.gold)),
                        )
                      else
                        const SizedBox(width: 80), 

                      if (!isConsentPage && !isLastPage) 
                        TextButton(
                          onPressed: _skipOnboarding,
                          child: const Text('PULAR', style: TextStyle(color: Colors.white70)),
                        )
                      else
                        const SizedBox(width: 80), 

                      if (!isLastPage)
                        ElevatedButton(
                          onPressed: isConsentPage && !_canFinalize
                            ? null
                            : () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                            ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: AppTheme.darkGreen,
                          ),
                          child: Text(isConsentPage ? 'FINALIZAR' : 'AVANÇAR'),
                        )
                      else 
                        ElevatedButton(
                          onPressed: _canFinalize ? _finalizeOnboarding : null, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: AppTheme.darkGreen,
                          ),
                          child: const Text('FINALIZAR'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}