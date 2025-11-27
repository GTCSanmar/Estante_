
import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks();
  Future<Book> saveBook(Book book);
  Future<void> deleteBook(String id);
  Future<Book> updateBook(Book book);
}