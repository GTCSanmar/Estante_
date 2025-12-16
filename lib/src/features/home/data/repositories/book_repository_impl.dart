// CRÍTICO: Importa a Entity SEM prefixo
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';
// Importa Data Sources
import 'package:estante/src/features/home/data/datasources/book_supabase_data_source.dart'; 
import 'package:estante/src/features/home/data/datasources/book_local_data_source.dart'; 
// Importa Mapper
import 'package:estante/src/features/home/data/mappers/book_mapper.dart'; 
// CRÍTICO: Importa o DTO com prefixo 'as dto'
import 'package:estante/src/features/home/data/dtos/book_dto.dart' as dto; 
// CRÍTICO: Importa o ReviewRepository para a exclusão em cascata
import 'package:estante/src/features/review/domain/repositories/review_repository.dart';


// O BookRepositoryImpl DEVE IMPLEMENTAR BookRepository
class BookRepositoryImpl implements BookRepository {
  // CRÍTICO: Agora temos um Data Source Local e um Remoto
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final BookMapper mapper;
  // CRÍTICO: Injeta o ReviewRepository para Deleção em Cascata
  final ReviewRepository reviewRepository;
  
  // CONSTRUTOR CORRIGIDO: Aceita o ReviewRepository
  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.mapper,
    required this.reviewRepository, // Recebe o ReviewRepository
  });
  
  // ----------------------------------------------------
  // 1. Lógica Cache-First e Sincronização
  // ----------------------------------------------------
  
  @override
  // CRÍTICO: Retorna List<Book>
  Future<List<Book>> getBooks() async {
    final localDtos = await localDataSource.getBooks();

    if (localDtos.isNotEmpty) {
      print("INFO: Carregando ${localDtos.length} livros do cache local.");
      // CRÍTICO: Mapeia de dto.BookDto para Book
      final localBooks = localDtos.map((dto) => mapper.toEntity(dto)).toList();
      
      // Inicia a sincronização em background (fire-and-forget)
      syncBooks(); 
      
      return localBooks;
    } else {
      print("INFO: Cache local vazio. Forçando sincronização completa.");
      return syncBooks(); 
    }
  }
  
  // Sincronização Push-Then-Pull (Remote -> Local)
  @override
  // CRÍTICO: Retorna List<Book>
  Future<List<Book>> syncBooks() async {
    try {
      // remoteDataSource agora retorna Book
      final remoteBooks = await remoteDataSource.getBooks();
      print("INFO: Sincronização Pull - Baixados ${remoteBooks.length} livros do Supabase.");

      // CRÍTICO: Mapeamento usando dto.BookDto
      final remoteDtos = remoteBooks.map((book) => mapper.toDto(book)).toList();
      
      await localDataSource.saveBooks(remoteDtos.cast<dto.BookDto>());

      return remoteBooks;
    } catch (e) {
      print("ERRO CRÍTICO na sincronização (BookRepository): $e");
      final localDtos = await localDataSource.getBooks();
      if (localDtos.isNotEmpty) {
         print("INFO: Falha na conexão. Retornando ${localDtos.length} livros do cache antigo.");
         // CRÍTICO: Mapeamento usando dto.BookDto
         return localDtos.map((dto) => mapper.toEntity(dto)).toList();
      }
      throw Exception('Não foi possível sincronizar ou carregar do cache: $e');
    }
  }
  
  // ----------------------------------------------------
  // 2. Persistência (Escrita)
  // ----------------------------------------------------

  @override
  // CRÍTICO: Argumento e Retorno usam Book
  Future<Book> saveBook(Book book) async {
    try {
      final savedBook = await remoteDataSource.saveBook(book); 
      syncBooks(); // PUSH-THEN-PULL
      return savedBook;
    } catch (e) {
      print("ERRO ao salvar livro no Repositório: $e");
      throw Exception("Falha ao salvar livro: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      // 1. DELEÇÃO EM CASCATA
      final reviews = await reviewRepository.getReviewsByBookId(id);
      
      for (var review in reviews) {
        await reviewRepository.deleteReview(review.id);
        print("INFO: Review ${review.id} deletada com sucesso.");
      }

      // 2. PUSH: Deleta no servidor remoto
      await remoteDataSource.deleteBook(id); 
      
      // 3. PULL: Recarrega do servidor e atualiza o cache local
      syncBooks(); 
      print("INFO: Livro e avaliações deletadas com sucesso.");
    } catch (e) {
      print("ERRO ao deletar livro no Repositório (ID: $id): $e"); 
      throw Exception("Falha ao deletar livro (ID: $id): ${e.toString()}"); 
    }
  }
  
  @override
  Future<Book> updateBook(Book book) => saveBook(book); 
}