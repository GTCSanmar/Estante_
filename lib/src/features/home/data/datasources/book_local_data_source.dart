import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:estante/src/features/home/data/dtos/book_dto.dart'; // Usamos DTOs para persistência
import 'package:estante/src/features/home/domain/entities/book.dart'; // Para tipos de retorno

// Contrato para o Data Source Local
abstract class BookLocalDataSource {
  Future<List<BookDto>> getBooks();
  Future<void> saveBooks(List<BookDto> books);
  Future<void> clearCache();
}

// Implementação que usa SharedPreferences
class BookSharedPreferencesDataSource implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;
  // Chave onde a lista de livros será armazenada
  static const String _booksKey = 'cached_books_list'; 

  BookSharedPreferencesDataSource({required this.sharedPreferences});

  @override
  Future<List<BookDto>> getBooks() async {
    try {
      final String? jsonString = sharedPreferences.getString(_booksKey);
      if (jsonString == null) {
        return [];
      }
      
      // Converte a string JSON para uma lista de Maps
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // Mapeia os Maps de volta para BookDto
      return jsonList.map((json) => BookDto.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao ler cache local de livros: $e');
      return [];
    }
  }

  @override
  Future<void> saveBooks(List<BookDto> books) async {
    // Converte a lista de DTOs em uma lista de Maps (JSON)
    final List<Map<String, dynamic>> jsonList = books.map((dto) => dto.toJson()).toList();
    
    // Converte a lista de Maps em uma string JSON para salvar
    final String jsonString = jsonEncode(jsonList);
    
    await sharedPreferences.setString(_booksKey, jsonString);
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_booksKey);
  }
}