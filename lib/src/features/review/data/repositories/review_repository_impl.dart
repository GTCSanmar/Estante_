import 'package:estante/src/features/review/domain/entities/review.dart';
import 'package:estante/src/features/review/domain/repositories/review_repository.dart';
// CRÍTICO: Importando o Data Source CORRETO (ReviewRemoteDataSource)
import 'package:estante/src/features/review/data/datasources/review_remote_data_source.dart'; 

// O ReviewRepositoryImpl DEVE IMPLEMENTAR ReviewRepository
class ReviewRepositoryImpl implements ReviewRepository {
  // CRÍTICO: O remoteDataSource DEVE ser do tipo ReviewRemoteDataSource
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createReview(Review review) async {
    return remoteDataSource.createReview(review);
  }

  @override
  Future<List<Review>> getReviewsByBookId(String bookId) async {
    return remoteDataSource.getReviewsByBookId(bookId);
  }

  @override
  Future<void> updateReview(Review review) async {
    return remoteDataSource.updateReview(review);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    return remoteDataSource.deleteReview(reviewId);
  }
}