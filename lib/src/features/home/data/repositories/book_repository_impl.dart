import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';
// Importa Data Sources
import 'package:estante/src/features/home/data/datasources/book_supabase_data_source.dart'; 
import 'package:estante/src/features/home/data/datasources/book_local_data_source.dart'; 
// Importa Mapper
import 'package:estante/src/features/home/data/mappers/book_mapper.dart'; 
import 'package:estante/src/features/home/data/dtos/book_dto.dart'; 


// O BookRepositoryImpl DEVE IMPLEMENTAR BookRepository
class BookRepositoryImpl implements BookRepository {
  // CRÍTICO: Agora temos um Data Source Local e um Remoto
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final BookMapper mapper;
  
  // CONSTRUTOR CORRIGIDO: Aceita o Data Source remoto e local
  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.mapper,
  });
  
  // ----------------------------------------------------
  // 1. Lógica Cache-First e Sincronização
  // ----------------------------------------------------
  
  @override
  Future<List<Book>> getBooks() async {
    // 1. Tentar carregar do cache local
    final localDtos = await localDataSource.getBooks();

    if (localDtos.isNotEmpty) {
      print("INFO: Carregando ${localDtos.length} livros do cache local.");
      // Mapeia DTOs locais para Entities e retorna
      final localBooks = localDtos.map((dto) => mapper.toEntity(dto)).toList();
      
      // Inicia a sincronização em background (fire-and-forget)
      syncBooks(); 
      
      return localBooks;
    } else {
      print("INFO: Cache local vazio. Forçando sincronização completa.");
      // Se não houver cache, força a sincronização completa
      return syncBooks(); 
    }
  }
  
  // Sincronização Push-Then-Pull (Remote -> Local)
  @override
  Future<List<Book>> syncBooks() async {
    try {
      // 1. PULL: Baixar os dados mais recentes do Supabase
      final remoteBooks = await remoteDataSource.getBooks();
      print("INFO: Sincronização Pull - Baixados ${remoteBooks.length} livros do Supabase.");

      // 2. Mapear Entities para DTOs (para salvar no cache)
      final remoteDtos = remoteBooks.map((book) => mapper.toDto(book)).toList();
      
      // 3. CACHE: Salvar a lista mais recente no cache local
      await localDataSource.saveBooks(remoteDtos as List<BookDto>);

      // 4. Retornar a lista de Entidades
      return remoteBooks;
    } catch (e) {
      print("ERRO CRÍTICO na sincronização (BookRepository): $e");
      // Se a sincronização falhar (ex: sem internet), retornar o cache antigo (ou lançar erro se o cache também falhar)
      final localDtos = await localDataSource.getBooks();
      if (localDtos.isNotEmpty) {
         print("INFO: Falha na conexão. Retornando ${localDtos.length} livros do cache antigo.");
         return localDtos.map((dto) => mapper.toEntity(dto)).toList();
      }
      // Lança o erro se não houver cache para fallback
      throw Exception('Não foi possível sincronizar ou carregar do cache: $e');
    }
  }
  
  // ----------------------------------------------------
  // 2. Persistência (Escrita)
  // ----------------------------------------------------

  @override
  Future<Book> saveBook(Book book) async {
    // 1. PUSH: Salva no servidor remoto (Supabase)
    final savedBook = await remoteDataSource.saveBook(book); 
    
    // 2. PULL: Recarrega do servidor e atualiza o cache local (garantindo o novo ID e o estado mais recente)
    // Isso é o PUSH-THEN-PULL
    syncBooks(); 
    
    return savedBook;
  }

  @override
  Future<void> deleteBook(String id) async {
    // 1. PUSH: Deleta no servidor remoto
    await remoteDataSource.deleteBook(id);
    
    // 2. PULL: Recarrega do servidor e atualiza o cache local
    syncBooks(); 
  }
  
  // Update é um save no nosso modelo
  @override
  Future<Book> updateBook(Book book) => saveBook(book); 
}