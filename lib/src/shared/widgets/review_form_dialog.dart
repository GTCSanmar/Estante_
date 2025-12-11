import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/features/review/domain/entities/review.dart'; // Entidade de Domínio

class ReviewFormDialog extends StatefulWidget {
  final String bookId;
  final String readerId;

  const ReviewFormDialog({
    super.key,
    required this.bookId,
    required this.readerId,
  });

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 3.0; // Nota inicial padrão

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      // 1. Criar a nova Entity Review a partir dos dados do formulário
      final newReview = Review(
        id: DateTime.now().microsecondsSinceEpoch.toString(), // ID de mock (será substituído pelo Supabase)
        bookId: widget.bookId,
        readerId: widget.readerId,
        rating: _rating,
        comment: _commentController.text.trim(),
        publishedAt: DateTime.now(),
      );

      // 2. Retorna a Entity pronta para o método que a chamou (onde será persistida)
      Navigator.of(context).pop(newReview);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkGreen,
      title: Text(
        'Avaliar Livro',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.gold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Seção da Nota (Rating)
              Text('Nota (${_rating.toStringAsFixed(1)} de 5):', style: const TextStyle(color: Colors.white70)),
              Slider(
                value: _rating,
                min: 0.0,
                max: 5.0,
                divisions: 10,
                activeColor: AppTheme.gold,
                inactiveColor: AppTheme.gold.withOpacity(0.3),
                onChanged: (double newValue) {
                  setState(() {
                    _rating = newValue;
                  });
                },
              ),
              
              const SizedBox(height: 15),

              // Campo de Comentário
              TextFormField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Seu Comentário',
                  hintText: 'O que você achou deste volume?',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O comentário não pode ser vazio.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: _submitReview,
          child: const Text('ENVIAR AVALIAÇÃO'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
        ),
      ],
    );
  }
}