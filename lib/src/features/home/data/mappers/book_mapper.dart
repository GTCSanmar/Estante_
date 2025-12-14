// CRÍTICO: Importa a Entity SEM prefixo para que a classe 'Book' seja reconhecida
import 'package:estante/src/features/home/domain/entities/book.dart'; 
// CRÍTICO: Importa o DTO com prefixo 'as dto'
import 'package:estante/src/features/home/data/dtos/book_dto.dart' as dto; 

class BookMapper {
  // CRÍTICO: Usa Book (sem prefixo) no tipo de retorno, e dto.BookDto no argumento
  Book toEntity(dto.BookDto dto) {
    return Book( // Usa construtor de Book
      id: dto.id ?? '0',
      title: dto.title,
      author: dto.author,
      // CRÍTICO: Se o page_count for NULL, use 0
      pageCount: dto.pageCount ?? 0, 
      // CRÍTICO: Se o is_reading for NULL, use false
      isReading: dto.isReading ?? false,
      description: dto.description, 
    );
  }

  dto.BookDto toDto(Book entity) { // Usa dto.BookDto no retorno, e Book no argumento
    return dto.BookDto(
      id: entity.id == '0' ? null : entity.id,
      title: entity.title,
      author: entity.author,
      // O DTO aceita int? e bool?
      pageCount: entity.pageCount, 
      isReading: entity.isReading,
      description: entity.description, 
    );
  }
}