// lib/src/features/review/data/datasources/review_remote_data_source.dart

import '../../domain/entities/review.dart';

// Define o contrato do Data Source Remoto para Avaliações
abstract class ReviewRemoteDataSource {
  Future<void> createReview(Review review);
  Future<List<Review>> getReviewsByBookId(String bookId);
  Future<void> updateReview(Review review);
  Future<void> deleteReview(String reviewId);
}