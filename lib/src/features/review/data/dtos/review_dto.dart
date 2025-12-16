// lib/src/features/review/data/dtos/review_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'review_dto.g.dart';

@JsonSerializable()
class ReviewDto {
  // Tipos simples e opcionais conforme o backend
  final String? id;
  
  // CRÍTICO: Mapeia o campo Dart 'bookId' para o snake_case 'book_id' do PostgreSQL
  @JsonKey(name: 'book_id') 
  final String? bookId;   
  
  // Mapeia o campo Dart 'readerId' para o snake_case 'reader_id' do PostgreSQL
  @JsonKey(name: 'reader_id') 
  final String? readerId; 
  
  final double? rating;
  final String? comment;
  
  // CRÍTICO: Mapeia para 'created_at' (coluna padrão do Supabase) em vez de 'published_at'
  @JsonKey(name: 'created_at') 
  final String? publishedAt; 

  ReviewDto({
    this.id,
    this.bookId,
    this.readerId,
    this.rating,
    this.comment,
    this.publishedAt,
  });

  // Métodos de serialização
  factory ReviewDto.fromJson(Map<String, dynamic> json) => _$ReviewDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewDtoToJson(this);
}