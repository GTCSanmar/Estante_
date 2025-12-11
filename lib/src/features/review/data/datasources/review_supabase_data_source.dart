import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:estante/src/features/review/data/dtos/review_dto.dart';
import 'package:estante/src/features/review/data/mappers/review_mapper.dart';
import 'package:estante/src/features/review/domain/entities/review.dart';
import 'review_remote_data_source.dart'; 

// IMPLEMENTAÇÃO SUPABASE REAL
class ReviewSupabaseDataSource implements ReviewRemoteDataSource {
  final SupabaseClient client;
  final ReviewMapper mapper;
  final String _tableName = 'reviews'; // Nome da tabela no Supabase

  ReviewSupabaseDataSource({required this.client, required this.mapper});

  // CRIAÇÃO DE AVALIAÇÃO
  @override
  Future<void> createReview(Review review) async {
    try {
      final reviewDto = mapper.toDto(review);
      
      // CRÍTICO: Ajustamos o payload para remover explicitamente o ID e o publishedAt
      // (que se mapeia para created_at no DTO).
      // Isso garante que o Supabase use a coluna 'created_at' gerada automaticamente.
      final payload = reviewDto.toJson()
        ..removeWhere((key, value) => key == 'id' || key == 'created_at'); 

      await client.from(_tableName).insert(payload);
      
    } on PostgrestException catch (e) {
      // Trata erros de banco de dados
      throw Exception('Erro ao criar avaliação no Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao criar avaliação: $e');
    }
  }

  // BUSCA DE AVALIAÇÕES POR LIVRO
  @override
  Future<List<Review>> getReviewsByBookId(String bookId) async {
    try {
      // CORREÇÃO: Usamos .select() e snake_case para o filtro book_id
      final List<dynamic> response = await client
          .from(_tableName)
          .select()
          .eq('book_id', bookId) 
          .order('created_at', ascending: false); // CRÍTICO: Ordena por created_at
      
      return response
          .map((json) => mapper.toEntity(ReviewDto.fromJson(json)))
          .toList();

    } on PostgrestException catch (e) {
      // Se a coluna publishedAt não existir, este erro será pego e exibido
      throw Exception('Erro ao buscar avaliações no Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar avaliações: $e');
    }
  }

  // ATUALIZAÇÃO E DELEÇÃO (Mantidos, mas garantimos que o UPDATE remova o created_at)
  
  @override
  Future<void> updateReview(Review review) async {
    try {
      final reviewDto = mapper.toDto(review);
      final payload = reviewDto.toJson()
        ..removeWhere((key, value) => key == 'created_at'); // Não atualiza o timestamp de criação

      await client.from(_tableName).update(payload).eq('id', review.id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao atualizar avaliação no Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao atualizar avaliação: $e');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await client.from(_tableName).delete().eq('id', reviewId);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao deletar avaliação no Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao deletar avaliação: $e');
    }
  }
}