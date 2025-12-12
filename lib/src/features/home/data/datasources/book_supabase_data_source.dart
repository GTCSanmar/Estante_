import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/features/home/data/mappers/book_mapper.dart';
import 'package:estante/src/features/home/data/dtos/book_dto.dart'; // Importa o DTO
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BookRemoteDataSource {
  Future<List<Book>> getBooks();
  Future<Book> saveBook(Book book);
  Future<void> deleteBook(String id);
}

class BookSupabaseDataSource implements BookRemoteDataSource {
  final SupabaseClient client;
  final BookMapper mapper;
  static const String _tableName = 'books'; 

  BookSupabaseDataSource({required this.client, required this.mapper});

  @override
  Future<List<Book>> getBooks() async {
    // CRÍTICO: Usamos .select() sem filtros (todos os livros)
    final List<dynamic> response = await client.from(_tableName).select();
    
    final List<dynamic> rawData = response as List<dynamic>;
    return rawData
      .map((json) => mapper.toEntity(BookDto.fromJson(json)))
      .toList();
  }

  // CRÍTICO: CORREÇÃO DA LÓGICA DE PERSISTÊNCIA (CREATE/UPDATE)
  @override
  Future<Book> saveBook(Book book) async {
    final bookDto = mapper.toDto(book);
    final isNew = book.id == '0'; 
    
    // Converte o DTO para o formato JSON que o Supabase espera.
    // O problema é que o DTO pode ter campos nulos que o Supabase não aceita no INSERT.
    final jsonPayload = bookDto.toJson()
      ..removeWhere((key, value) => value == null || key == 'id'); // Remove nulos e o ID (para INSERT)
    
    if (isNew) {
      // Operação INSERT (Criação)
      // Usamos .select() para garantir que o registro retorne o ID gerado pelo banco de dados
      final List<dynamic> response = await client.from(_tableName)
        .insert(jsonPayload) // Usamos o payload ajustado
        .select(); 

      if (response.isEmpty) {
        throw Exception('Supabase Insert Error: Resposta vazia.');
      }
      // Retorna a Entidade completa, incluindo o ID gerado
      return mapper.toEntity(BookDto.fromJson(response[0])); 
    } else {
      // Operação UPDATE (Edição)
      await client.from(_tableName)
        .update(jsonPayload)
        .eq('id', book.id);
      
      return book; 
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    // Implementação do método de deleção
    await client.from(_tableName).delete().eq('id', id);
  }
}