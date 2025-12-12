import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/shared/widgets/review_form_dialog.dart';
import 'package:estante/src/features/review/domain/entities/review.dart';
import 'package:estante/src/features/review/domain/repositories/review_repository.dart';
import '../../../../main.dart'; // Acesso ao reviewRepository (instância global)

// CRÍTICO: Constante de UUID de Mock VÁLIDO.
// O Supabase precisa de um UUID no formato XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
const String MOCK_READER_UUID = '00000000-0000-0000-0000-000000000001'; 

class BookDetailDialog extends StatefulWidget {
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
  State<BookDetailDialog> createState() => _BookDetailDialogState();
}

class _BookDetailDialogState extends State<BookDetailDialog> {
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  // Busca a lista de Reviews para o livro atual
  Future<void> _loadReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });
    try {
      // Chamada ao Repositório para buscar as avaliações
      final reviews = await reviewRepository.getReviewsByBookId(widget.book.id);
      if (mounted) {
        setState(() {
          _reviews = reviews;
          _isLoadingReviews = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingReviews = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar avaliações: $e')),
        );
      }
    }
  }

  // Método para abrir o diálogo de avaliação e persistir o Review
  void _openReviewForm(BuildContext context) async {
    // CRÍTICO: USANDO O UUID DE MOCK VÁLIDO
    const String simulatedReaderId = MOCK_READER_UUID; 

    final newReview = await showDialog<Review>(
      context: context,
      builder: (context) => ReviewFormDialog(
        bookId: widget.book.id,
        readerId: simulatedReaderId,
      ),
      barrierDismissible: false, // Não permite fechar sem ação
    );

    if (newReview != null) {
      try {
        // Chamada ao Repositório para persistir (CREATE)
        await reviewRepository.createReview(newReview); 
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avaliação enviada com sucesso para o Duque!')),
          );
          _loadReviews(); // Recarrega a lista para mostrar o novo item
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao enviar avaliação: $e')),
          );
        }
      }
    }
  }

  // Constrói o widget de listagem de avaliações
  Widget _buildReviewList() {
    if (_isLoadingReviews) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
    }
    if (_reviews.isEmpty) {
      return const Text('Nenhuma avaliação encontrada.', style: TextStyle(color: Colors.white54));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: AppTheme.gold, size: 16),
              const SizedBox(width: 5),
              Text(
                '${review.rating.toStringAsFixed(1)}: ${review.comment}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkGreen,
      title: Text(widget.book.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold)),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Autor: ${widget.book.author}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            Text('Páginas: ${widget.book.pageCount}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            Text(
              widget.book.isReading ? 'Status: Em Leitura' : 'Status: Na Estante',
              style: TextStyle(color: widget.book.isReading ? AppTheme.wineRed : Colors.white70),
            ),
            const SizedBox(height: 20),
            
            // BOTÃO AVALIAR VOLUME
            ElevatedButton.icon(
              onPressed: () => _openReviewForm(context), 
              icon: const Icon(Icons.star, color: AppTheme.darkGreen),
              label: const Text('AVALIAR VOLUME', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
              ),
            ),
            
            const SizedBox(height: 10),
            const Divider(color: Colors.white12),
            const Text('Avaliações:', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 5),
            
            // LISTAGEM DE REVIEWS
            _buildReviewList(),

            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: <Widget>[
        // Botões de CRUD (Item 5/6/7)
        TextButton(
          child: const Text('FECHAR', style: TextStyle(color: Colors.white54)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onEdit(widget.book); 
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold),
          child: const Text('EDITAR', style: TextStyle(color: AppTheme.darkGreen)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onRemove(widget.book); 
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.wineRed),
          child: const Text('REMOVER'),
        ),
      ],
    );
  }
}   