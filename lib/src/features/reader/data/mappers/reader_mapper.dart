// lib/src/features/reader/data/mappers/reader_mapper.dart

import '../../domain/entities/reader.dart';
import '../dtos/reader_dto.dart';

class ReaderMapper {

  // Conversão: DTO (Data) para Entity (Domain)
  Reader toEntity(ReaderDto dto) {
    if (dto.id == null || dto.name == null || dto.email == null || dto.memberSince == null) {
      throw const FormatException('ReaderDto is incomplete for entity conversion.');
    }
    
    return Reader(
      id: dto.id!,
      name: dto.name!,
      email: dto.email!,
      isActive: dto.isActive ?? false, // Normalização: assume false se nulo
      memberSince: DateTime.parse(dto.memberSince!), // Parsing para tipo forte DateTime
      passwordHash: dto.passwordHash, // Mapeia o hash apenas se presente
    );
  }

  // Conversão: Entity (Domain) para DTO (Data)
  ReaderDto toDto(Reader entity) {
    return ReaderDto(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      isActive: entity.isActive,
      // Formatação para string ISO8601
      memberSince: entity.memberSince.toIso8601String(), 
      // CRÍTICO: Somente inclui o hash se ele foi explicitamente fornecido,
      // geralmente para operações de atualização de senha.
      passwordHash: entity.passwordHash, 
    );
  }
}