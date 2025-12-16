// lib/src/features/authors/data/dtos/author_dto.dart

import 'package:json_annotation/json_annotation.dart';

part 'author_dto.g.dart';

@JsonSerializable()
class AuthorDto {
  // Tipos simples e opcionais conforme o backend (fiel ao schema remoto)
  final String? id;
  final String? name;
  final String? biography;
  final String? createdAt; // DateTime como String ISO8601 no DTO

  AuthorDto({
    this.id,
    this.name,
    this.biography,
    this.createdAt,
  });

  // Métodos de serialização
  factory AuthorDto.fromJson(Map<String, dynamic> json) => _$AuthorDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorDtoToJson(this);
}