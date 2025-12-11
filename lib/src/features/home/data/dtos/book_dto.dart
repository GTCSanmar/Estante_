import 'package:json_annotation/json_annotation.dart';

part 'book_dto.g.dart';

@JsonSerializable()
class BookDto {
  final String? id;
  final String? title;
  final String? author;
  final int? pageCount;
  final bool? isReading;

  BookDto({
    this.id,
    this.title,
    this.author,
    this.pageCount,
    this.isReading,
  });

  // Métodos de serialização
  factory BookDto.fromJson(Map<String, dynamic> json) => _$BookDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BookDtoToJson(this);
}