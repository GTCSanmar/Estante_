import 'package:json_annotation/json_annotation.dart';

part 'book_dto.g.dart';

// CRÍTICO: Mantemos FieldRename.snake para o resto do DTO (title, author)
@JsonSerializable(fieldRename: FieldRename.snake)
class BookDto {
  final String? id;
  final String title;
  final String author;
  
  // CRÍTICO: Força o nome do campo JSON para 'pageCount' (camelCase)
  @JsonKey(name: 'pageCount')
  final int? pageCount; 
  
  // CRÍTICO: Força o nome do campo JSON para 'isReading' (camelCase)
  @JsonKey(name: 'isReading')
  final bool? isReading;
  
  // CRÍTICO: MANTEMOS O IGNORE na description (coluna ausente no BD)
  @JsonKey(ignore: true) 
  final String description; 

  BookDto({
    this.id,
    required this.title,
    required this.author,
    this.pageCount, 
    this.isReading, 
    this.description = '', 
  });

  // Usa a sintaxe padrão sem o prefixo 
  factory BookDto.fromJson(Map<String, dynamic> json) => _$BookDtoFromJson(json);
  // CORREÇÃO: Deve passar 'this' (a instância atual) para toJson()
  Map<String, dynamic> toJson() => _$BookDtoToJson(this);
}