import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class BookActionsDialog extends StatelessWidget {
  final Book book;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const BookActionsDialog({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // CRITÉRIO DE ACEITAÇÃO: O diálogo deve ser não-dismissable ao tocar fora.
      // Isso é controlado na chamada showDialog(), mas colocamos um fundo escuro.
      backgroundColor: AppTheme.darkGreen,
      
      title: Text(
        'Ações para "${book.title}"',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.gold),
      ),
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ação 1: EDITAR (Delega para o handler de Edição)
          ListTile(
            leading: const Icon(Icons.edit, color: AppTheme.gold),
            title: const Text('Editar', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o diálogo de ações
              onEdit(); // Delega para o handler na HomePage (que abrirá o BookEditDialog)
            },
          ),
          // Ação 2: REMOVER (Delega para o handler de Remoção)
          ListTile(
            leading: const Icon(Icons.delete, color: AppTheme.wineRed),
            title: const Text('Remover', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o diálogo de ações
              onRemove(); // Delega para o handler na HomePage (que abrirá a confirmação)
            },
          ),
        ],
      ),
      
      actions: [
        // Ação 3: FECHAR
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('FECHAR', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}

// Helper para exibição não-dismissable
Future<void> showBookActionsDialog({
  required BuildContext context,
  required Book book,
  required VoidCallback onEdit,
  required VoidCallback onRemove,
}) {
  return showDialog(
    context: context,
    builder: (context) => BookActionsDialog(
      book: book,
      onEdit: onEdit,
      onRemove: onRemove,
    ),
    barrierDismissible: false, // CRITÉRIO DE ACEITAÇÃO: Não-dismissable
  );
}