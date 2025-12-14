// lib/src/features/home/domain/entities/book.dart
// CRÍTICO: Removendo todas as referências ao DTO e JSON serializable.

class Book {
  final String id;
  final String title;
  final String author;
  final int pageCount;
  final bool isReading;
  final String description; // Adicionado para o resumo da IA

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pageCount,
    this.isReading = false,
    this.description = '', // Valor padrão vazio
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? pageCount,
    bool? isReading,
    String? description, // Adicionado ao copyWith
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      pageCount: pageCount ?? this.pageCount,
      isReading: isReading ?? this.isReading,
      description: description ?? this.description,
    );
  }
}