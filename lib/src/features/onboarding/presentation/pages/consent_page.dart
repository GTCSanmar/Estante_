import 'package:flutter/material.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import '../../../../../main.dart'; // Acesso ao prefsService

// O conteúdo longo (pergaminhos) é definido AQUI, eliminando a dependência do AppConfig
const String _dummyPolicyContent = """
## 📜 Política de Privacidade do Reino (Versão 1.0)

Por ordem do Duque, todos os leitores devem aderir às seguintes Leis da Livraria. Este documento estabelece que seus dados (apenas preferências de leitura e estatísticas anônimas) serão usados unicamente para melhorar sua experiência na estante. Seus dados jamais serão vendidos a reinos vizinhos ou comerciantes. A aceitação deste pergaminho é o selo de confiança entre o Leitor e o Duque. 
[1] Coleta de Dados: Coletamos apenas o ID do livro, a página atual e o status de leitura. Nenhuma informação pessoal identificável (nome, localização, etc.) é armazenada sem o seu consentimento explícito.
[2] Uso da Informação: Os dados são utilizados para: a) Oferecer recomendações de leitura; b) Melhorar a funcionalidade da estante; c) Garantir a integridade dos volumes.
[3] Direitos do Leitor (LGPD): Você tem o direito de revogar seu consentimento e solicitar a exclusão de seus dados a qualquer momento, através do menu 'Configurações' na Estante principal.

--- [FIM DO PERGAMINHO 1] ---
""";
    
const String _dummyTermsContent = """
## 📜 Termos de Uso e Manutenção da Estante
    
Os Termos de Uso do Reino proíbem a cópia não autorizada dos manuscritos e o uso de magia negra para alterar o conteúdo da biblioteca. Qualquer violação resultará na suspensão imediata da sua licença de leitura.
[1] Propriedade Intelectual: Todo o conteúdo, design e código-fonte pertencem ao Duque e são protegidos pelas leis do Reino. A reprodução sem permissão é estritamente proibida.
[2] Conduta do Usuário: É proibido o uso de linguagem imprópria, ameaças ou qualquer conduta que perturbe a paz e a serenidade da Livraria.
[3] Resolução de Disputas: Qualquer disputa será resolvida pelo Conselho de Sábios da Corte do Duque, cuja decisão é final e inapelável.

--- [FIM DO PERGAMINHO 2] ---
""";

class ConsentPage extends StatefulWidget {
  final Function(bool) onConsentChanged;

  const ConsentPage({super.key, required this.onConsentChanged});

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  // === Scroll e Estado de Leitura ===
  final ScrollController _scrollController = ScrollController();
  bool _canMarkAsRead = false;
  double _scrollProgress = 0.0;
  
  bool _consentGiven = false;
  
  // Conteúdo Consolidado (Garantia de rolagem) - Multiplicado para forçar o scroll
  final String _consolidatedContent = (_dummyPolicyContent * 3) + "\n\n---\n\n" + (_dummyTermsContent * 3);


  @override
  void initState() {
    super.initState();
    // 1. Inicializa o estado de consentimento e leitura
    _checkInitialStatus();
    // 2. Adiciona o Listener do Scroll
    _scrollController.addListener(_updateScrollProgress);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollProgress(); // Checagem inicial
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkInitialStatus() {
    _consentGiven = prefsService.getMarketingConsent;
    // Se o Onboarding já foi concluído antes, assumimos que já leu os termos
    if (prefsService.getOnboardingCompleted) {
       _canMarkAsRead = true;
    }
    // Notifica o PageView do estado inicial
    _updateConsentState();
  }

  // --- Lógica de Scroll (RF-3) ---
  void _updateScrollProgress() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    // Calcula o progresso para a barra
    double newProgress = 0.0;
    if (maxScroll <= 0) {
      newProgress = 1.0;
    } else {
      newProgress = currentScroll / maxScroll;
    }

    // Se o usuário rolou até 99% do final e não marcou como lido ainda
    if (newProgress >= 0.99 && !_canMarkAsRead) {
      _canMarkAsRead = true;
      // Salva o estado de leitura imediatamente para o PrefsService
      prefsService.setPrivacyPolicyRead(true); 
      prefsService.setTermsRead(true); 
    }
    
    // Atualiza a UI (progresso da barra)
    setState(() {
      _scrollProgress = newProgress;
      _updateConsentState(); // Reavalia se o botão Finalizar pode ser habilitado
    });
  }

  // --- Lógica de Consentimento (RF-4) ---
  void _updateConsentState() {
    // Se a leitura foi confirmada, o PageView pode habilitar o botão
    if(_canMarkAsRead) {
       // Notifica o PageView para habilitar o botão Finalizar
       widget.onConsentChanged(true); 
    } else {
       widget.onConsentChanged(false);
    }
  }

  // A lógica de aceitação está no PageView, mas o Opt-in é salvo aqui
  void _acceptOptIn() {
    prefsService.setMarketingConsent(_consentGiven); 
  }


  @override
  Widget build(BuildContext context) {
    final bool isReadyToConsent = _canMarkAsRead;
    
    return Column(
      children: [
        // 1. Barra de Progresso (Feedback Visual)
        LinearProgressIndicator(
          value: _scrollProgress.clamp(0.0, 1.0),
          backgroundColor: AppTheme.darkGreen,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.gold),
        ),

        // 2. Título
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Pergaminhos Reais de Confiança (LGPD)',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
            textAlign: TextAlign.center,
          ),
        ),

        // 3. Conteúdo Riscado (Pergaminho que Rola)
        Expanded(
          child: Container(
            // Fundo do pergaminho (Bege forte)
            color: const Color(0xFFFFF0C7), 
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                // Conteúdo Principal
                Text(
                  _consolidatedContent,
                  style: TextStyle(
                    color: AppTheme.darkGreen, // Cor da Tinta - DEVE ser visível
                    fontSize: 16.0,
                    height: 1.5,
                  ),
                ),
                // Espaço de segurança no final do pergaminho
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),

        // 4. Seção de Consentimento (Opt-in)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                // Checkbox só pode ser alterado se o conteúdo foi lido
                value: _consentGiven,
                onChanged: isReadyToConsent ? (bool? value) {
                  setState(() {
                    _consentGiven = value ?? false;
                    _acceptOptIn(); // Salva o Opt-in
                  });
                } : null, // Desabilita o checkbox se não leu
                activeColor: AppTheme.gold,
              ),
              Flexible(
                child: Text(
                  isReadyToConsent ? 'Eu Li e Aceito os termos acima (Consentimento de Marketing/Analytics).' : 'Role para o final para habilitar o aceite.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}