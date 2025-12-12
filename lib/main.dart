import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 

// --- Imports da Camada de Domínio e Dados para LIVRO ---
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';
import 'package:estante/src/features/home/data/repositories/book_repository_impl.dart'; 
import 'package:estante/src/features/home/data/datasources/book_supabase_data_source.dart'; 
import 'package:estante/src/features/home/data/datasources/book_local_data_source.dart'; 
import 'package:estante/src/features/home/data/mappers/book_mapper.dart'; 
import 'package:estante/src/features/home/data/dtos/book_dto.dart'; 
import 'package:estante/src/features/home/presentation/book_store.dart'; 

// --- Imports da Camada de Domínio e Dados para AVALIAÇÃO (REVIEW) ---
import 'package:estante/src/features/review/domain/repositories/review_repository.dart';
import 'package:estante/src/features/review/data/repositories/review_repository_impl.dart'; 
import 'package:estante/src/features/review/data/datasources/review_supabase_data_source.dart'; 
import 'package:estante/src/features/review/data/mappers/review_mapper.dart'; 
import 'package:estante/src/features/review/data/dtos/review_dto.dart'; 

// --- Imports de UI e Serviços ---
import 'package:estante/src/app_config.dart';
import 'package:estante/src/shared/services/prefs_service.dart';

// --- CHAVES DE CONFIGURAÇÃO SUPABASE (USO DIRETO) ---
const SUPABASE_URL = 'https://ttslodaucuzjjzdktafp.supabase.co'; 
const SUPABASE_ANON_KEY = 'sb_publishable_xGLmIHYu8Q4S2jQBMHRs-w_oxL-apVm'; 
// --------------------------------------------------------------------------

// --- INSTÂNCIAS GLOBAIS (Service Locator) ---
final PrefsService prefsService = PrefsService();
late final BookRepository bookRepository;
late final ReviewRepository reviewRepository; 
bool isDependenciesInitialized = false; 

// CRÍTICO: Variáveis globais para o Provider/Cache
late final BookStore bookStore; 
late final SharedPreferences sharedPreferencesInstance; 

// Função que realiza toda a inicialização assíncrona
Future<void> initDependencies() async {
  if (isDependenciesInitialized) return;

  try {
    // 1. Inicializa o Supabase
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANON_KEY,
    );

    final supabaseClient = Supabase.instance.client;

    // 2. Inicializa o SharedPreferences
    sharedPreferencesInstance = await SharedPreferences.getInstance(); 
    
    // 3. Inicializa o PrefsService (LGPD)
    await prefsService.init(sharedPreferencesInstance);

    // 4. Inicializa as Dependências do LIVRO (Book)
    final bookMapper = BookMapper(); 
    final bookRemoteDataSource = BookSupabaseDataSource( 
      client: supabaseClient,
      mapper: bookMapper,
    );
    // Inicializa o Data Source Local
    final bookLocalDataSource = BookSharedPreferencesDataSource(
      sharedPreferences: sharedPreferencesInstance, 
    );
    
    // Repositório agora recebe o Data Source Local (Cache-First)
    bookRepository = BookRepositoryImpl(
      remoteDataSource: bookRemoteDataSource,
      localDataSource: bookLocalDataSource, 
      mapper: bookMapper,
    );
    
    // Inicializa a Store com o Repositório
    bookStore = BookStore(repository: bookRepository);

    // 5. Inicializa as Dependências de AVALIAÇÃO (Review)
    final reviewMapper = ReviewMapper(); 
    final reviewDataSource = ReviewSupabaseDataSource( 
      client: supabaseClient,
      mapper: reviewMapper,
    );
    reviewRepository = ReviewRepositoryImpl(remoteDataSource: reviewDataSource); 

    isDependenciesInitialized = true;
  } catch (e) {
    print("ERRO CRÍTICO NA INICIALIZAÇÃO DE DEPENDÊNCIAS: $e");
    // Lançamos o erro para ser capturado se o FutureBuilder estiver sendo usado
    rethrow; 
  }
}

// CRÍTICO: main() AGORA É ASSÍNCRONO E AGUARDA AS DEPENDÊNCIAS (Chamando o initDependencies APENAS na SplashPage)
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // CRÍTICO: Rodamos o App diretamente, injetando o Provider com uma instância de mock
  // O initDependencies() será chamado e aguardado na SplashPage.
  runApp(
    // NOTE: Usamos .value para injetar o Provider globalmente
    ChangeNotifierProvider<BookStore>(
      // Usamos uma instância mock ou vazia até que a SplashPage inicialize a real
      create: (context) => BookStore(repository: bookRepository), // Cria a Store
      child: const RootApp(),
    ),
  );
}

// CRÍTICO: RootApp é o wrapper final
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppConfig(); 
  }
}