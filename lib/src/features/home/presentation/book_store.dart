import 'package:flutter/material.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';

class BookStore extends ChangeNotifier {
  final BookRepository _repository;
  
  List<Book> _books = [];
  List<Book> get books => _books;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BookStore({required BookRepository repository}) : _repository = repository;

  // Lógica de Sincronização e Carregamento (Cache-First)
  Future<void> loadBooks({bool forceSync = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // O repositório agora lida com a lógica Cache-First (Local -> Remote)
      if (forceSync) {
        // Se for uma sincronização forçada (ex: botão de refresh)
        _books = await _repository.syncBooks(); 
      } else {
        // Carrega do Local/Supabase (lógica do repositório)
        _books = await _repository.getBooks(); 
      }
      
    } catch (e) {
      _errorMessage = 'Falha ao carregar/sincronizar livros: $e';
      print("ERRO NA BOOK STORE: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Funções de CRUD delegadas ao Repositório
  Future<void> saveBook(Book book) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.saveBook(book);
      await loadBooks(forceSync: true); // Sincroniza após salvar (Push-Then-Pull)
    } catch (e) {
      _errorMessage = 'Erro ao salvar livro: $e';
      notifyListeners();
      // Não redefinimos isLoading aqui, para forçar o usuário a ver o erro.
    }
  }

  Future<void> updateBook(Book book) => saveBook(book); // Update é um save
  
  Future<void> deleteBook(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.deleteBook(id);
      await loadBooks(forceSync: true); // Sincroniza após deletar
    } catch (e) {
      _errorMessage = 'Erro ao remover livro: $e';
      notifyListeners();
    }
  }
}