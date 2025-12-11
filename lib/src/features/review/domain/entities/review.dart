// lib/src/features/review/domain/entities/review.dart
// Camada de Domínio: Regras e Estruturas de Dados Puras

class Review {
  final String id;
  final String bookId;
  final String readerId; // Quem fez a avaliação
  final double rating;  // Nota de 1.0 a 5.0
  final String comment;
  final DateTime publishedAt; // Quando a avaliação foi publicada (será mapped do created_at do BD)

  Review({
    required this.id,
    required this.bookId,
    required this.readerId,
    required this.rating,
    required this.comment,
    required this.publishedAt,
  });

  // Método auxiliar para criar cópias modificadas
  Review copyWith({
    String? id,
    String? bookId,
    String? readerId,
    double? rating,
    String? comment,
    DateTime? publishedAt,
  }) {
    return Review(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      readerId: readerId ?? this.readerId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}