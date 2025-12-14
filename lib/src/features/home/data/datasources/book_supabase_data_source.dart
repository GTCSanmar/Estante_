import 'package:supabase_flutter/supabase_flutter.dart';
// CRÍTICO: Importa a Entity SEM prefixo para resolver o erro 'Book isn't a type'.
import 'package:estante/src/features/home/domain/entities/book.dart'; 
import 'package:estante/src/features/home/data/mappers/book_mapper.dart';
// CRÍTICO: Importa o DTO com prefixo 'as dto' para resolver a ambiguidade BookDto.
import 'package:estante/src/features/home/data/dtos/book_dto.dart' as dto;
// REMOVIDO: A importação 'book_remote_data_source.dart' que estava faltando.

// CRÍTICO: Interface BookRemoteDataSource DEFINIDA AQUI para resolver o erro 'uri_does_not_exist'
abstract class BookRemoteDataSource {
  // Usando o tipo Book (sem prefixo)
  Future<List<Book>> getBooks();
  Future<Book> saveBook(Book book);
  Future<void> deleteBook(String id);
}

// IMPLEMENTAÇÃO SUPABASE REAL
class BookSupabaseDataSource implements BookRemoteDataSource {
  final SupabaseClient client;
  final BookMapper mapper;
  static const String _tableName = 'books'; 

  BookSupabaseDataSource({required this.client, required this.mapper});

  @override
  Future<List<Book>> getBooks() async {
    try {
      final List<dynamic> response = await client.from(_tableName).select();
      
      final List<dynamic> rawData = response as List<dynamic>;
      // CRÍTICO: Mapeamento usando dto.BookDto
      return rawData
        .map((json) => mapper.toEntity(dto.BookDto.fromJson(json)))
        .toList();
    } on PostgrestException catch (e) {
        print("ERRO SUPABASE GET: ${e.message}");
        throw Exception("Falha ao buscar livros: ${e.message}");
    }
  }

  @override
  Future<Book> saveBook(Book book) async {
    // A variável 'book' é do tipo Book (Entity)
    final bookDto = mapper.toDto(book); 
    // CRÍTICO: Usando a classe Book
    final isNew = book.id == '0'; 
    
    // Remove ID e campos nulos para o INSERT/UPDATE
    final jsonPayload = bookDto.toJson()
      ..removeWhere((key, value) => value == null || key == 'id');
    
    try {
      if (isNew) {
        final List<dynamic> response = await client.from(_tableName)
          .insert(jsonPayload)
          .select(); 

        if (response.isEmpty) {
          throw Exception('Supabase Insert Error: Resposta vazia.');
        }
        // CRÍTICO: Mapeamento usando dto.BookDto
        return mapper.toEntity(dto.BookDto.fromJson(response[0])); 
      } else {
        await client.from(_tableName)
          .update(jsonPayload)
          .eq('id', book.id);
        
        return book; 
      }
    } on PostgrestException catch (e) {
        print("ERRO SUPABASE SAVE/UPDATE: ${e.message}");
        throw Exception("Falha ao salvar livro: ${e.message}");
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      // Comando padrão para deletar um registro com base no ID
      await client.from(_tableName).delete().eq('id', id);
      print("INFO: DELETE Sucesso para o ID: $id");
    } on PostgrestException catch (e) {
      // CRÍTICO: Imprime o erro exato do RLS no terminal
      print("ERRO CRÍTICO SUPABASE DELETE (RLS?): ${e.message}");
      throw Exception('Falha ao deletar livro (RLS?): ${e.message}');
    } catch (e) {
      print("ERRO INESPERADO DELETE: $e");
      throw Exception('Erro inesperado ao deletar: $e');
    }
  }
}