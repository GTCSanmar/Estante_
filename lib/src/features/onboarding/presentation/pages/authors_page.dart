import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';
import '../../../../../../main.dart'; // Acesso ao bookRepository

class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  final BookRepository _bookRepository = bookRepository;
  
  List<String> _authors = [];
  bool _isLoading = true;
  Map<String, int> _authorCounts = {}; 

  @override
  void initState() {
    super.initState();
    _loadAuthors();
  }

  Future<void> _loadAuthors() async {
    setState(() {
      _isLoading = true;
      _authorCounts = {}; 
    });

    final List<Book> books = await _bookRepository.getBooks();

    final Map<String, int> counts = {};
    books.forEach((book) {
      final authorName = book.author.trim();
      if (authorName.isNotEmpty) {
        counts[authorName] = (counts[authorName] ?? 0) + 1;
      }
    });

    final List<String> uniqueAuthors = counts.keys.toList()..sort();

    setState(() {
      _authors = uniqueAuthors; 
      _authorCounts = counts; 
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Autores'),
        backgroundColor: AppTheme.darkGreen,
        foregroundColor: AppTheme.gold,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
    }

    if (_authors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 80, color: AppTheme.gold),
            const SizedBox(height: 20),
            Text(
              'Nenhum Autor Cadastrado.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('Voltar para a Estante'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _authors.length,
      itemBuilder: (context, index) {
        final author = _authors[index];
        final bookCount = _authorCounts[author] ?? 0; 
        
        return ListTile(
          leading: const Icon(Icons.person_pin, color: AppTheme.gold),
          title: Text(author, style: const TextStyle(color: Colors.white)),
          subtitle: Text('$bookCount livro(s) na estante', style: const TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detalhes de ${author}')),
            );
          },
        );
      },
    );
  }

  
}