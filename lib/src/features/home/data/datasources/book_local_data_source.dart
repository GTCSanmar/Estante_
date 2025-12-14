import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// REMOVIDO: Unused import: 'package:estante/src/features/home/domain/entities/book.dart'; 
// CRÍTICO: Importa o DTO com prefixo 'as dto'
import 'package:estante/src/features/home/data/dtos/book_dto.dart' as dto; 

// Contrato para o Data Source Local
abstract class BookLocalDataSource {
  // CRÍTICO: O contrato usa o DTO, não a Entity
  Future<List<dto.BookDto>> getBooks();
  Future<void> saveBooks(List<dto.BookDto> books);
  Future<void> clearCache();
}

// Implementação que usa SharedPreferences
class BookSharedPreferencesDataSource implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;
  // Chave onde a lista de livros será armazenada
  static const String _booksKey = 'cached_books_list'; 

  BookSharedPreferencesDataSource({required this.sharedPreferences});

  @override
  Future<List<dto.BookDto>> getBooks() async {
    try {
      final String? jsonString = sharedPreferences.getString(_booksKey);
      if (jsonString == null) {
        return [];
      }
      
      // Converte a string JSON para uma lista de Maps (List<dynamic>)
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // Mapeia os Maps de volta para dto.BookDto
      return jsonList.map((json) => dto.BookDto.fromJson(json)).toList();
    } catch (e) {
      // O [avoid_print] é de severidade baixa e pode ser ignorado por enquanto.
      print('Erro ao ler cache local de livros: $e'); 
      return [];
    }
  }

  @override
  Future<void> saveBooks(List<dto.BookDto> books) async {
    // Converte a lista de DTOs em uma lista de Maps (JSON)
    // CRÍTICO: O tipo de entrada já é List<dto.BookDto>
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