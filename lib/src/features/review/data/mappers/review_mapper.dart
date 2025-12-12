// lib/src/features/review/data/mappers/review_mapper.dart

import '../../domain/entities/review.dart';
import '../dtos/review_dto.dart';

class ReviewMapper {

  // Conversão: DTO (Data) para Entity (Domain)
  Review toEntity(ReviewDto dto) {
    // A chave publishedAt (que mapeia para created_at no JSON) é necessária
    if (dto.id == null || dto.bookId == null || dto.readerId == null || dto.publishedAt == null || dto.rating == null) {
      throw const FormatException('ReviewDto is incomplete for entity conversion.');
    }
    
    return Review(
      id: dto.id!,
      bookId: dto.bookId!,
      readerId: dto.readerId!,
      rating: dto.rating!,
      comment: dto.comment ?? '', // Normalização
      // Parsing para tipo forte DateTime
      publishedAt: DateTime.parse(dto.publishedAt!), 
    );
  }

  // Conversão: Entity (Domain) para DTO (Data)
  ReviewDto toDto(Review entity) {
    return ReviewDto(
      id: entity.id,
      bookId: entity.bookId,
      readerId: entity.readerId,
      rating: entity.rating,
      comment: entity.comment,
      // CRÍTICO: Não enviamos o publishedAt no INSERT, pois o BD usa created_at (automático).
      // Se enviarmos, o Supabase tentará mapear para a coluna (que pode estar ausente).
      // Deixamos como null, permitindo que o Supabase use o created_at do servidor.
      publishedAt: null, 
    );
  }
}