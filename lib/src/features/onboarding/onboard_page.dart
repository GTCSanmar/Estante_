import 'package:flutter/material.dart';
import 'package:estante/src/features/onboarding/pages/page_one.dart';
import 'package:estante/src/features/onboarding/pages/page_two.dart';
import 'package:estante/src/features/onboarding/pages/consent_page.dart';
import 'package:estante/src/features/onboarding/pages/go_to_access_page.dart';
import 'package:estante/src/shared/widgets/dots_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == 3;
    final bool isFirstPage = _currentPage == 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const [
                  OnboardingPageOne(),
                  OnboardingPageTwo(),
                  ConsentPage(),
                  GoToAccessPage(),
                ],
              ),
            ),
            if (!isLastPage)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: DotsIndicator(
                  currentIndex: _currentPage,
                  itemCount: 4,
                ),
              ),
            // Controles de Navegação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão Pular - Visível, mas que navega para a página de Consentimento
                  if (!isLastPage)
                    TextButton(
                      onPressed: () {
                        _pageController.animateToPage(2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: const Text('Pular'),
                    ),
                  // Botão Voltar - Oculto na primeira e na última página
                  if (!isFirstPage && !isLastPage)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: const Text('Voltar'),
                    ),
                  // Botão Avançar - Oculto na última página
                  if (!isLastPage)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: const Text('Avançar'),
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