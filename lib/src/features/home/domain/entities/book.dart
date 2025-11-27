import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  final String id;
  final String title;
  final String author;
  final int pageCount;
  final bool isReading;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pageCount,
    this.isReading = false,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? pageCount,
    bool? isReading,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      pageCount: pageCount ?? this.pageCount,
      isReading: isReading ?? this.isReading,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
Map<String, dynamic> toJson() => _$BookToJson(this);
}