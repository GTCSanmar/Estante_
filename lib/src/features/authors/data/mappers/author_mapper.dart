// lib/src/features/authors/data/mappers/author_mapper.dart

import '../../domain/entities/author.dart';
import '../dtos/author_dto.dart';

class AuthorMapper {

  // Conversão: DTO (Data) para Entity (Domain)
  // Centraliza a normalização e o parsing de tipos fortes.
  Author toEntity(AuthorDto dto) {
    if (dto.id == null || dto.name == null || dto.createdAt == null) {
      throw const FormatException('AuthorDto is incomplete for entity conversion.');
    }
    
    return Author(
      id: dto.id!,
      name: dto.name!,
      biography: dto.biography ?? '', // Normalização para string vazia
      createdAt: DateTime.parse(dto.createdAt!), // Parsing para tipo forte DateTime
    );
  }

  // Conversão: Entity (Domain) para DTO (Data)
  // Centraliza a formatação para o transporte/persistência.
  AuthorDto toDto(Author entity) {
    return AuthorDto(
      id: entity.id,
      name: entity.name,
      biography: entity.biography,
      createdAt: entity.createdAt.toIso8601String(), // Formatação para string
    );
  }
}