
import 'dart:convert';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _bookListKey = 'book_list';

class BookRepositoryImpl implements BookRepository {
  final SharedPreferences sharedPreferences;

  BookRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<Book>> getBooks() async {
    final jsonString = sharedPreferences.getString(_bookListKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Book.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<Book> saveBook(Book book) async {
    List<Book> books = await getBooks();
    
    final isNew = book.id.isEmpty;
    final bookToSave = isNew 
      ? book.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
      : book;

    if (isNew) {
      books.add(bookToSave);
    } else {
      final index = books.indexWhere((b) => b.id == bookToSave.id);
      if (index != -1) {
        books[index] = bookToSave;
      }
    }

    final jsonList = books.map((b) => b.toJson()).toList();
    await sharedPreferences.setString(_bookListKey, jsonEncode(jsonList));
    return bookToSave;
  }
  
  @override
  Future<void> deleteBook(String id) async {
    List<Book> books = await getBooks();
    books.removeWhere((book) => book.id == id);
    
    final jsonList = books.map((b) => b.toJson()).toList();
    await sharedPreferences.setString(_bookListKey, jsonEncode(jsonList));
  }
  
  @override
  Future<Book> updateBook(Book book) => saveBook(book);
}