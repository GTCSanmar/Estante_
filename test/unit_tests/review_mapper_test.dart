
import 'package:flutter_test/flutter_test.dart';
import 'package:estante/src/data/dtos/review_dto.dart';
import 'package:estante/src/data/mappers/review_mapper.dart';
import 'package:estante/src/domain/entities/review.dart';

void main() {
  group('ReviewMapper', () {
    test('should correctly map ReviewDto to Review Entity', () {
      final reviewDto = ReviewDto(
        review_id: 'rev-001',
        book_id: 'book-101',
        user_id: 'user-25',
        review_rating: 5,
        review_comment: 'Excelente livro sobre DDD!',
        review_date: '2025-10-26',
      );

      final reviewEntity = ReviewMapper.toEntity(reviewDto);

      expect(reviewEntity, isA<Review>());
      expect(reviewEntity.id, 'rev-001');
      expect(reviewEntity.bookId, 'book-101');
      expect(reviewEntity.userId, 'user-25');
      expect(reviewEntity.rating, 5);
      expect(reviewEntity.comment, 'Excelente livro sobre DDD!');
    });

    test('should correctly map Review Entity to ReviewDto', () {
      final reviewEntity = Review(
        id: 'rev-002',
        bookId: 'book-202',
        userId: 'user-30',
        rating: 3,
        comment: 'Bom, mas esperava mais da história.',
        date: '2025-11-05',
      );

      final reviewDto = ReviewMapper.toDto(reviewEntity);

      expect(reviewDto, isA<ReviewDto>());
      expect(reviewDto.review_id, 'rev-002');
      expect(reviewDto.book_id, 'book-202');
      expect(reviewDto.user_id, 'user-30');
      expect(reviewDto.review_rating, 3);
      expect(reviewDto.review_comment, 'Bom, mas esperava mais da história.');
    });
  });
}

