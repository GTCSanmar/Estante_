import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class BookEditDialog extends StatefulWidget {
  final Book book;

  const BookEditDialog({super.key, required this.book});

  @override
  State<BookEditDialog> createState() => _BookEditDialogState();
}

class _BookEditDialogState extends State<BookEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _pagesController;
  late bool _isReading;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _pagesController = TextEditingController(text: widget.book.pageCount.toString());
    _isReading = widget.book.isReading;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedBook = widget.book.copyWith(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        pageCount: int.tryParse(_pagesController.text) ?? 0,
        isReading: _isReading,
      );
      
      
      Navigator.of(context).pop(updatedBook); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkGreen,
      title: Text('Editar Livro: ${widget.book.title}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título', labelStyle: TextStyle(color: Colors.white70)),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? 'O título não pode ser vazio.' : null,
              ),
              
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Autor', labelStyle: TextStyle(color: Colors.white70)),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? 'O autor não pode ser vazio.' : null,
              ),
              TextFormField(
                controller: _pagesController,
                decoration: const InputDecoration(labelText: 'Páginas', labelStyle: TextStyle(color: Colors.white70)),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: (value) => int.tryParse(value!) == null ? 'Deve ser um número válido.' : null,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    value: _isReading,
                    onChanged: (bool? value) {
                      setState(() {
                        _isReading = value ?? false;
                      });
                    },
                    activeColor: AppTheme.gold,
                  ),
                  const Text('Em Leitura', style: TextStyle(color: Colors.white70)),
                ],
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
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
          child: const Text('SALVAR EDIÇÕES', style: TextStyle(color: AppTheme.darkGreen)),
        ),
      ],
    );
  }
}