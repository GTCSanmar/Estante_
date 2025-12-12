import '../../domain/entities/book.dart';
import '../dtos/book_dto.dart';
// Note: Este arquivo assume que você criou um book_dto.dart com json_annotation

class BookMapper {
  
  // Conversão: DTO (Data) para Entity (Domain)
  Book toEntity(BookDto dto) {
    // Implemente lógica de validação aqui se necessário
    if (dto.id == null || dto.title == null || dto.author == null) {
      throw const FormatException('BookDto is incomplete for entity conversion.');
    }
    
    return Book(
      id: dto.id!,
      title: dto.title!,
      author: dto.author!,
      pageCount: dto.pageCount ?? 0,
      isReading: dto.isReading ?? false,
    );
  }

  // Conversão: Entity (Domain) para DTO (Data)
  BookDto toDto(Book entity) {
    return BookDto(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      pageCount: entity.pageCount,
      isReading: entity.isReading,
    );
  }
}