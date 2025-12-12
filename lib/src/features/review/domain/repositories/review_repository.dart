// lib/src/features/review/domain/repositories/review_repository.dart

import '../entities/review.dart';

// Interface que define o contrato do Repositório de Avaliações (Review)
abstract class ReviewRepository {
  // RF-Avaliação 1: Envia uma nova avaliação para persistência
  Future<void> createReview(Review review);

  // RF-Avaliação 2: Busca todas as avaliações de um livro específico
  Future<List<Review>> getReviewsByBookId(String bookId);

  // RF-Avaliação 3: Atualiza o comentário ou nota de uma avaliação existente
  Future<void> updateReview(Review review);

  // RF-Avaliação 4: Deleta uma avaliação
  Future<void> deleteReview(String reviewId);
}