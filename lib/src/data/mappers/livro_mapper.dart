import '../../domain/entities/livro.dart';
import '../dtos/livro_dto.dart';

class LivroMapper {
  static Livro fromDto(LivroDto dto) {
    return Livro(
      id: dto.id,
      titulo: dto.titulo,
      autor: dto.autor,
      capaUrl: dto.capa, 
      paginasLidas: dto.paginasLidas,
      totalPaginas: dto.paginasTotal, 
    );
  }

  static LivroDto toDto(Livro entity) {
    return LivroDto(
      id: entity.id,
      titulo: entity.titulo,
      autor: entity.autor,
      capa: entity.capaUrl,
      paginasLidas: entity.paginasLidas,
      paginasTotal: entity.totalPaginas,
    );
  }
}