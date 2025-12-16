import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import '../../../../../main.dart'; // Para acessar a função de chamada da IA

class BookEditDialog extends StatefulWidget {
  final Book book;

  const BookEditDialog({super.key, required this.book});

  @override
  State<BookEditDialog> createState() => _BookEditDialogState();
}

class _BookEditDialogState extends State<BookEditDialog> {
  final _formKey = GlobalKey<FormState>();
  // CRÍTICO: Usando Controllers para atualização programática (IA)
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late String _author;
  late int _pageCount;
  late bool _isReading;
  
  bool _isGenerating = false;
  String? _iaValidationMessage;

  @override
  void initState() {
    super.initState();
    
    // Inicializa Controllers com os valores da Entity
    _titleController = TextEditingController(text: widget.book.title);
    _descriptionController = TextEditingController(text: widget.book.description);
    
    _author = widget.book.author;
    _pageCount = widget.book.pageCount; // Valor corrigido de persistência
    _isReading = widget.book.isReading; // Valor corrigido de persistência
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // NOVO MÉTODO: Chama a IA para gerar o resumo do livro
  Future<void> _generateDescription(BuildContext context) async {
    final title = _titleController.text.trim();
    final author = _author.trim();
    
    if (title.isEmpty || author.isEmpty) {
      setState(() {
        _iaValidationMessage = 'Forneça o Título e o Autor para gerar um resumo.';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _iaValidationMessage = null;
      _descriptionController.text = 'Gerando resumo...'; // Feedback imediato
    });

    try {
      final prompt = "Sugira um resumo conciso (2 frases) para o livro: '$title' de '$author'.";
      
      // Chamada à função global de IA (definida no main.dart)
      final result = await generateContentFromGemini(prompt, useSearch: true);
      
      if (result['error'] != null) {
        throw Exception(result['error']);
      }

      final generatedText = result['text'] ?? "Não foi possível gerar um resumo.";

      setState(() {
        // CRÍTICO: Atualiza o Controller diretamente para preencher a caixa de texto
        _descriptionController.text = generatedText.trim(); 
        _isGenerating = false;
        _iaValidationMessage = null; // Limpa qualquer mensagem de erro
      });

    } catch (e) {
      setState(() {
        _isGenerating = false;
        _iaValidationMessage = 'Falha na comunicação com a IA: ${e.toString()}';
        _descriptionController.text = ''; // Limpa o campo em caso de erro
      });
    }
  }

  // NOVO MÉTODO: Constrói o campo de descrição com o botão de IA
  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botão de Geração de Resumo
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : () => _generateDescription(context),
          icon: _isGenerating 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.darkGreen))
              : const Icon(Icons.auto_stories, color: AppTheme.darkGreen),
          label: Text(
            _isGenerating ? 'GERANDO RESUMO...' : 'GERAR RESUMO INTELIGENTE',
            style: const TextStyle(color: AppTheme.darkGreen),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.gold,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        
        if (_iaValidationMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _iaValidationMessage!,
              style: const TextStyle(color: AppTheme.wineRed, fontSize: 12),
            ),
          ),

        // Campo de Texto para Descrição (Permite edição manual)
        const SizedBox(height: 10),
        TextFormField(
          // CRÍTICO: Conecta o Controller aqui
          controller: _descriptionController,
          maxLines: 4,
          // Removed onChanged as the Controller manages the value
          decoration: InputDecoration(
            labelText: 'Descrição / Resumo',
            hintText: 'Descrição ou resumo gerado pela IA...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white10,
            labelStyle: const TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }


  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final resultBook = widget.book.copyWith(
        title: _titleController.text.trim(),
        author: _author,
        pageCount: _pageCount, 
        isReading: _isReading,
        description: _descriptionController.text.trim(), // Salva o texto do Controller
      );
      
      // CRÍTICO: Comando de DEBUG para verificar os valores antes de salvar
      print('DEBUG PERSISTÊNCIA: PageCount capturado: ${resultBook.pageCount}');
      print('DEBUG PERSISTÊNCIA: IsReading capturado: ${resultBook.isReading}');
      
      Navigator.of(context).pop(resultBook);
    }
  }

  // --- Funções de UI (Omitidas) ---
  InputDecoration _inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white10,
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkGreen,
      title: Text(
        widget.book.id == '0' ? 'Novo Livro' : 'Editar Livro',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Campo Título
              TextFormField(
                // CRÍTICO: Conecta o Controller aqui
                controller: _titleController,
                decoration: _inputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'O título é obrigatório.' : null,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Campo Autor
              TextFormField(
                initialValue: _author,
                onChanged: (value) => _author = value,
                decoration: _inputDecoration(labelText: 'Autor'),
                validator: (value) => value!.isEmpty ? 'O autor é obrigatório.' : null,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Campo Páginas
              TextFormField(
                initialValue: _pageCount.toString(), 
                keyboardType: TextInputType.number,
                // CRÍTICO: Atualiza a variável de estado _pageCount
                onChanged: (value) {
                  _pageCount = int.tryParse(value) ?? 0;
                },
                decoration: _inputDecoration(labelText: 'Contagem de Páginas'),
                validator: (value) => (int.tryParse(value ?? '') ?? 0) < 0 ? 'Não pode ser negativo.' : null,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Checkbox Em Leitura
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
              const SizedBox(height: 20),
              
              // Campo de Descrição com IA
              _buildDescriptionField(context),
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
          onPressed: _isGenerating ? null : _saveForm, // Desabilita se a IA estiver rodando
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
          child: const Text('SALVAR', style: TextStyle(color: AppTheme.darkGreen)),
        ),
      ],
    );
  }
}