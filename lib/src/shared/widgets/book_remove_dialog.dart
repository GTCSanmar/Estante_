import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class BookRemoveDialog extends StatelessWidget {
  final Book book;

  const BookRemoveDialog({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkGreen,
      title: const Text('Confirmação de Remoção', style: TextStyle(color: AppTheme.wineRed)),
      content: Text(
        'Tem certeza que deseja remover permanentemente o livro "${book.title}" da sua estante?',
        style: const TextStyle(color: Colors.white70),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Retorna false (não remover)
          child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // Retorna true (remover)
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.wineRed),
          child: const Text('REMOVER'),
        ),
      ],
    );
  }
}