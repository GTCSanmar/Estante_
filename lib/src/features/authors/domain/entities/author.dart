// lib/src/features/authors/domain/entities/author.dart

class Author {
  // Tipagem forte e invariantes de domínio
  final String id;
  final String name;
  final String biography;
  final DateTime createdAt;

  Author({
    required this.id,
    required this.name,
    required this.biography,
    required this.createdAt,
  });

  // Método copyWith para operações de atualização
  Author copyWith({
    String? id,
    String? name,
    String? biography,
    DateTime? createdAt,
  }) {
    return Author(
      id: id ?? this.id,
      name: name ?? this.name,
      biography: biography ?? this.biography,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}