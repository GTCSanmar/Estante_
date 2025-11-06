
class LivroDto {
  final String id;
  final String titulo;
  final String autor;
  final String capa; 
  final int paginasLidas;
  final int paginasTotal; 

  LivroDto({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.capa,
    required this.paginasLidas,
    required this.paginasTotal,
  });

  factory LivroDto.fromJson(Map<String, dynamic> json) {
    return LivroDto(
      id: json['id'] as String,
      titulo: json['title'] as String,
      autor: json['author'] as String,
      capa: json['cover_url'] as String,
      paginasLidas: json['read_pages'] as int,
      paginasTotal: json['total_pages'] as int,
    );
  }
}