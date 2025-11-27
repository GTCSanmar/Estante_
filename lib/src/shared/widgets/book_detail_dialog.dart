import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class BookDetailDialog extends StatelessWidget {
  final Book book;
  final Function(Book) onEdit;
  final Function(Book) onRemove;

  const BookDetailDialog({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkGreen,
      title: Text(book.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold)),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Autor: ${book.author}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            Text('Páginas: ${book.pageCount}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            Text(
              book.isReading ? 'Status: Em Leitura' : 'Status: Na Estante',
              style: TextStyle(color: book.isReading ? AppTheme.wineRed : Colors.white70),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('FECHAR', style: TextStyle(color: Colors.white54)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8), 
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit(book); 
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
          child: const Text('EDITAR', style: TextStyle(color: AppTheme.darkGreen)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onRemove(book); 
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.wineRed),
          child: const Text('REMOVER'),
        ),
      ],
    );
  }
}