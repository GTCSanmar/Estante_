// lib/src/features/reader/data/dtos/reader_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'reader_dto.g.dart';

@JsonSerializable()
class ReaderDto {
  // Tipos simples conforme o backend
  final String? id;
  final String? name;
  final String? email;
  final bool? isActive;
  final String? memberSince; // DateTime como String ISO8601 no DTO
  final String? passwordHash; // Campo sensível: pode vir como null do servidor

  ReaderDto({
    this.id,
    this.name,
    this.email,
    this.isActive,
    this.memberSince,
    this.passwordHash,
  });

  // Métodos de serialização
  factory ReaderDto.fromJson(Map<String, dynamic> json) => _$ReaderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReaderDtoToJson(this);
}