// lib/src/features/home/domain/repositories/book_repository.dart
// Esta é a interface (o Contrato) que a Camada de Domínio enxerga.
import '../entities/book.dart'; // CRÍTICO: Importa Entidade SEM prefixo

abstract class BookRepository {
  // CRÍTICO: Usa a Entidade sem prefixo
  Future<List<Book>> getBooks();
  Future<Book> saveBook(Book book);
  Future<void> deleteBook(String id);
  Future<Book> updateBook(Book book);
  
  // CRÍTICO: Adicionar o método de sincronização ao contrato
  Future<List<Book>> syncBooks();
}