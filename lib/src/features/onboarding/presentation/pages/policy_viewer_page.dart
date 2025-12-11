import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import '../../../../../../main.dart'; // Acesso ao prefsService

class PolicyViewerPage extends StatefulWidget {
  final String title;
  final String policyKey;
  final String policyContent;

  const PolicyViewerPage({
    super.key,
    required this.title,
    required this.policyKey,
    required this.policyContent,
  });

  @override
  State<PolicyViewerPage> createState() => _PolicyViewerPageState();
}

class _PolicyViewerPageState extends State<PolicyViewerPage> {
  final ScrollController _scrollController = ScrollController();
  bool _canMarkAsRead = false;
  double _scrollProgress = 0.0;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollProgress);
    // Adia a checagem inicial para o próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollProgress(); 
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    setState(() {
      // CORREÇÃO: Se não há o que rolar, assume que está no fim
      if (maxScroll <= 0) {
        _scrollProgress = 1.0;
      } else {
        _scrollProgress = currentScroll / maxScroll;
      }

      if (_scrollProgress >= 0.99 && !_canMarkAsRead) {
        _canMarkAsRead = true;
      }
    });
  }

  void _markAsRead() async {
    if (_canMarkAsRead) {
      // 1. Salva o estado de leitura usando o PrefsService
      if (widget.policyKey == 'privacy') {
        await prefsService.setPrivacyPolicyRead(true); 
      } else if (widget.policyKey == 'terms') {
        await prefsService.setTermsRead(true); 
      }
      
      // 2. Apenas retorna 'true' para a página anterior (ConsentPage)
      if (mounted) {
        Navigator.of(context).pop(true); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.darkGreen,
        foregroundColor: AppTheme.gold,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _scrollProgress.clamp(0.0, 1.0),
            backgroundColor: AppTheme.darkGreen,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.gold),
          ),
          Expanded(
            child: Container(
              // Fundo do pergaminho (Bege forte)
              color: const Color(0xFFFFF0C7), 
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                controller: _scrollController,
                children: [
                  // Conteúdo do Pergaminho
                  Text(
                    widget.policyContent,
                    style: TextStyle(
                      color: AppTheme.darkGreen, // Cor da Tinta
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                  
                  // CRÍTICO: ADICIONA ESPAÇO MAIOR PARA FORÇAR O SCROLL
                  const SizedBox(height: 1500), 
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _canMarkAsRead ? _markAsRead : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: _canMarkAsRead ? AppTheme.gold : AppTheme.darkGreen.withOpacity(0.5),
                foregroundColor: AppTheme.darkGreen,
              ),
              child: Text(
                _canMarkAsRead ? 'Marcar como Lido' : 'Role para Ler (${(_scrollProgress * 100).toInt()}% lido)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}