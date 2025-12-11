// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => ReviewDto(
  id: json['id'] as String?,
  bookId: json['book_id'] as String?,
  readerId: json['reader_id'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  comment: json['comment'] as String?,
  publishedAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ReviewDtoToJson(ReviewDto instance) => <String, dynamic>{
  'id': instance.id,
  'book_id': instance.bookId,
  'reader_id': instance.readerId,
  'rating': instance.rating,
  'comment': instance.comment,
  'created_at': instance.publishedAt,
};
