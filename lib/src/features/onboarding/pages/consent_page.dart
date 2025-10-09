import 'package:flutter/material.dart';

class ConsentPage extends StatefulWidget {
  const ConsentPage({super.key});

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exemplo de uma imagem para o slide
          Image.asset('assets/images/onboarding_three.png', height: 200),
          const SizedBox(height: 32),
          Text(
            'Respeitamos sua privacidade',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Precisamos do seu consentimento para enviar notícias sobre novos livros e promoções.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _consentGiven,
                onChanged: (bool? value) {
                  setState(() {
                    _consentGiven = value ?? false;
                  });
                },
              ),
              const Text('Concordo com os termos de privacidade.'),
            ],
          ),
        ],
      ),
    );
  }
}