// lib/src/features/onboarding/presentation/pages/consent_page.dart

import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/constants/app_routes.dart'; // Import necessário
import '../../../../../main.dart'; // Acesso ao prefsService

class ConsentPage extends StatefulWidget {
  final Function(bool) onConsentChanged;

  const ConsentPage({super.key, required this.onConsentChanged});

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _consentGiven = false;
  bool _privacyRead = false;
  bool _termsRead = false;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialStatus();
    });
  }

  void _checkInitialStatus() {
    _privacyRead = prefsService.getPrivacyPolicyRead;
    _termsRead = prefsService.getTermsRead;
    _consentGiven = prefsService.getMarketingConsent;
    
    setState(() {
      _updateConsentState();
    });
  }

  void _updateConsentState() {
    final bool allPoliciesRead = _privacyRead && _termsRead;
    
    if(allPoliciesRead) {
       widget.onConsentChanged(_consentGiven); 
    } else {
       widget.onConsentChanged(false);
    }
  }

  Future<void> _openPolicyViewer(String title, String policyKey) async {
    final result = await Navigator.pushNamed(
      context, 
      AppRoutes.policyViewer,
      arguments: {
        'title': title,
        'policyKey': policyKey,
      },
    );
    
    if (result == true) {
      setState(() {
         _privacyRead = prefsService.getPrivacyPolicyRead;
         _termsRead = prefsService.getTermsRead;
        _updateConsentState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allPoliciesRead = _privacyRead && _termsRead;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.gavel, size: 80, color: AppTheme.gold),
          const SizedBox(height: 32),
          Text(
            'Pergaminhos Reais de Confiança (LGPD)',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          ListTile(
            leading: Icon(_privacyRead ? Icons.check_circle : Icons.warning_rounded, color: _privacyRead ? AppTheme.gold : AppTheme.wineRed),
            title: const Text('Política de Privacidade do Reino', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
            onTap: () => _openPolicyViewer('Política de Privacidade', 'privacy'),
            dense: true,
            tileColor: AppTheme.darkGreen.withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(_termsRead ? Icons.check_circle : Icons.warning_rounded, color: _termsRead ? AppTheme.gold : AppTheme.wineRed),
            title: const Text('Termos de Uso do Duque', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
            onTap: () => _openPolicyViewer('Termos de Uso', 'terms'),
            dense: true,
            tileColor: AppTheme.darkGreen.withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),

          const SizedBox(height: 32),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _consentGiven,
                onChanged: allPoliciesRead ? (bool? value) {
                  setState(() {
                    _consentGiven = value ?? false;
                    widget.onConsentChanged(_consentGiven); // Notifica o PageView
                    prefsService.setMarketingConsent(_consentGiven); // Salva o Opt-in
                  });
                } : null, 
                activeColor: AppTheme.gold,
              ),
              Flexible(
                child: Text(
                  allPoliciesRead ? 'Eu Li e Aceito os termos acima (Consentimento de Marketing/Analytics).' : 'Leia todos os Pergaminhos para habilitar o aceite.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}