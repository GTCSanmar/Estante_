import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import '../../../../../main.dart'; // Acesso ao prefsService

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
      _scrollProgress = maxScroll > 0 ? currentScroll / maxScroll : 1.0;
      if (_scrollProgress >= 0.99 && !_canMarkAsRead) {
        _canMarkAsRead = true;
      }
    });
  }

  void _markAsRead() async {
    if (_canMarkAsRead) {
      if (widget.policyKey == 'privacy') {
        await prefsService.setPrivacyPolicyRead(true); 
      } else if (widget.policyKey == 'terms') {
        await prefsService.setTermsRead(true); 
      }
      
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
              color: const Color(0xFFFFF0C7), 
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                controller: _scrollController,
                children: [
                  Text(
                    widget.policyContent,
                    style: TextStyle(
                      color: AppTheme.darkGreen, 
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 800),
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
                _canMarkAsRead ? 'Marcar como Lido' : 'Role para Ler (${(_scrollProgress * 100).toInt()}%)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}