import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/widgets/book_detail_dialog.dart';
import 'package:estante/src/shared/widgets/book_edit_dialog.dart';
import 'package:estante/src/shared/widgets/book_remove_dialog.dart'; 
import 'package:estante/src/shared/constants/app_routes.dart';
import '../../../../../main.dart'; // Acesso à instância global do bookRepository

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> _books = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });
    final loadedBooks = await bookRepository.getBooks();
    setState(() {
      _books = loadedBooks;
      _isLoading = false;
    });
  }
  
  void _openCreateDialog() async {
    final newBook = await showDialog<Book>(
      context: context,
      builder: (context) => BookEditDialog(
        book: Book(id: '', title: '', author: '', pageCount: 0),
      ),
    );

    if (newBook != null) {
      await bookRepository.saveBook(newBook);
      _loadBooks(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livro "${newBook.title}" adicionado à estante.')),
      );
    }
  }

  void _editBook(Book book) async {
    final updatedBook = await showDialog<Book>(
      context: context,
      builder: (context) => BookEditDialog(book: book),
    );
    
    if (updatedBook != null) {
      await bookRepository.updateBook(updatedBook);
      _loadBooks(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livro "${updatedBook.title}" editado com sucesso.')),
      );
    }
  }

  void _removeBook(Book book) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => BookRemoveDialog(book: book),
    );

    if (shouldRemove == true) {
      await bookRepository.deleteBook(book.id);
      _loadBooks(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livro "${book.title}" removido permanentemente.')),
      );
    }
  }

  void _toggleReadingStatus(Book book) async {
     final updatedBook = book.copyWith(isReading: !book.isReading);
     await bookRepository.updateBook(updatedBook);
     _loadBooks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Estante (Livraria do Duque)'),
        backgroundColor: AppTheme.darkGreen,
        foregroundColor: AppTheme.gold,
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.darkGreen,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.darkGreen,
              ),
              child: Text(
                'Entidades do Reino',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.gold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: AppTheme.gold),
              title: const Text('Livros (Estante)', style: TextStyle(color: Colors.white70)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white70),
              title: const Text('Autores', style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                Navigator.pushNamed(context, AppRoutes.authors); 
              },
            ),
          ],
        ),
      ),
      body: _buildBookList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        backgroundColor: AppTheme.gold,
        child: const Icon(Icons.add, color: AppTheme.darkGreen),
      ),
    );
  }
  
  Widget _buildBookList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
    }
    
    if (_books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shelves, size: 64, color: AppTheme.gold),
            const SizedBox(height: 16),
            Text('Nenhum Livro Encontrado.', style: TextStyle(color: AppTheme.gold)),
            Text('Use o botão "+" para catalogar seu primeiro volume.', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return ListTile(
          leading: IconButton(
             icon: Icon(book.isReading ? Icons.auto_stories : Icons.book, 
                color: book.isReading ? AppTheme.wineRed : AppTheme.gold),
             onPressed: () => _toggleReadingStatus(book), // Ação rápida para status
          ),
          title: Text(book.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text('${book.author} | ${book.pageCount} páginas', style: const TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => BookDetailDialog(
                book: book, 
                onEdit: _editBook, // Item 6
                onRemove: _removeBook, // Item 7
              ),
            );
          },
        );
      },
    );
  }
}