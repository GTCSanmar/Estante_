import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http; // Importar o pacote http

// --- Imports da Camada de Domínio e Dados para LIVRO (Cache-First) ---
import 'package:estante/src/features/home/domain/repositories/book_repository.dart';
import 'package:estante/src/features/home/data/repositories/book_repository_impl.dart'; 
import 'package:estante/src/features/home/data/datasources/book_supabase_data_source.dart'; 
import 'package:estante/src/features/home/data/datasources/book_local_data_source.dart'; // Local Data Source
import 'package:estante/src/features/home/data/mappers/book_mapper.dart'; 
import 'package:estante/src/features/home/data/dtos/book_dto.dart'; 
import 'package:estante/src/features/home/presentation/book_store.dart'; // Book Store (Provider)

// --- Imports da Camada de Domínio e Dados para AVALIAÇÃO (REVIEW) ---
import 'package:estante/src/features/review/domain/repositories/review_repository.dart';
import 'package:estante/src/features/review/data/repositories/review_repository_impl.dart'; 
import 'package:estante/src/features/review/data/datasources/review_supabase_data_source.dart'; 
import 'package:estante/src/features/review/data/mappers/review_mapper.dart'; 
import 'package:estante/src/features/review/data/dtos/review_dto.dart'; 

// --- Imports NOVO Perfil/Foto ---
import 'package:estante/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:estante/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:estante/src/features/profile/data/local_photo_store.dart';
import 'package:estante/src/features/profile/presentation/profile_controller.dart'; // NOVO CONTROLLER

// --- Imports de UI e Serviços ---
import 'package:estante/src/app_config.dart';
import 'package:estante/src/shared/services/prefs_service.dart';

// --- CHAVES DE CONFIGURAÇÃO SUPABASE (USO DIRETO) ---
const SUPABASE_URL = 'https://ttslodaucuzjjzdktafp.supabase.co'; 
const SUPABASE_ANON_KEY = 'sb_publishable_xGLmIHYu8Q4S2jQBMHRs-w_oxL-apVm'; 
// NOVO: Adicione uma chave de API para o Gemini
const GEMINI_API_KEY = 'AIzaSyDj4swDdGhTmloxzwRCjsLaFdttLWUpd4o'; // Deixe vazia; será substituída em tempo de execução

// --- INSTÂNCIAS GLOBAIS (Service Locator) ---
// CRÍTICO: Renomeado de 'prefsServiceInstance' de volta para 'prefsService'
final PrefsService prefsService = PrefsService();
// Variáveis late para inicialização assíncrona
late final BookRepository bookRepository;
late final ReviewRepository reviewRepository; 
// NOVO: Variáveis late para o Perfil
late final ProfileRepository profileRepository; 
late final ProfileController profileController; 

bool isDependenciesInitialized = false; 
late final BookStore bookStore; 
late final SharedPreferences sharedPreferencesInstance; 


// NOVO: Função Global para Chamar a API Gemini (Feature IA)
Future<Map<String, dynamic>> generateContentFromGemini(String prompt, {bool useSearch = false}) async {
  // CRÍTICO: Configuração da API
  const model = 'gemini-2.5-flash-preview-09-2025';
  final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$GEMINI_API_KEY';
  
  final payload = {
      "contents": [{"parts": [{"text": prompt}]}],
      "tools": useSearch ? [{"google_search": {}}] : null, // Habilita o Google Search para grounding
  };

  // Lógica de Retry (Exponencial Backoff)
  const maxRetries = 3;
  for (int attempt = 0; attempt < maxRetries; attempt++) {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final text = result['candidates']?[0]?['content']?['parts']?[0]?['text'];
        
        if (text != null && text.isNotEmpty) {
          return {'text': text};
        }
        return {'error': 'A IA não retornou texto válido.'};
      } else {
        // Tentativa falhou, mas não é um erro de servidor (4xx), tentar novamente se for 5xx
        if (response.statusCode >= 500) {
           await Future.delayed(Duration(seconds: 1 << attempt)); // Espera 1s, 2s, 4s...
           continue; 
        }
        return {'error': 'Erro HTTP: ${response.statusCode} - ${response.body}'};
      }
    } catch (e) {
      if (attempt < maxRetries - 1) {
        await Future.delayed(Duration(seconds: 1 << attempt));
        continue;
      }
      return {'error': 'Falha na requisição de rede: $e'};
    }
  }
  return {'error': 'Todas as tentativas de API falharam.'};
}

// Função que realiza toda a inicialização assíncrona
Future<void> initDependencies() async {
  if (isDependenciesInitialized) return;

  // 1. Inicializa o Supabase
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  final supabaseClient = Supabase.instance.client;

  // 2. Inicializa o SharedPreferences
  sharedPreferencesInstance = await SharedPreferences.getInstance(); 
  
  // 3. Inicializa o PrefsService (LGPD)
  // CRÍTICO: Usa a instância global que renomeamos (prefsService)
  await prefsService.init(sharedPreferencesInstance);

  // 4. Inicializa DEPENDÊNCIAS DE PERFIL (NOVO)
  final photoStore = LocalPhotoStore();
  profileRepository = ProfileRepositoryImpl(
    preferencesService: prefsService, // <<< Nome da instância corrigido
    photoStore: photoStore,
  );
  profileController = ProfileController(repository: profileRepository); // Cria o Controller
  
  // 5. Inicializa as Dependências de AVALIAÇÃO (Review) - DEVE ser feita ANTES do Book
  final reviewMapper = ReviewMapper(); 
  final reviewDataSource = ReviewSupabaseDataSource( 
    client: supabaseClient,
    mapper: reviewMapper,
  );
  reviewRepository = ReviewRepositoryImpl(remoteDataSource: reviewDataSource); 

  // 6. Inicializa as Dependências do LIVRO (Book) - Cache-First
  final bookMapper = BookMapper(); 
  final bookRemoteDataSource = BookSupabaseDataSource( 
    client: supabaseClient,
    mapper: bookMapper,
  );
  final bookLocalDataSource = BookSharedPreferencesDataSource(
    sharedPreferences: sharedPreferencesInstance, 
  );
  
  // CRÍTICO: Injeta a DEPENDÊNCIA do ReviewRepository no BookRepository
  bookRepository = BookRepositoryImpl(
    remoteDataSource: bookRemoteDataSource,
    localDataSource: bookLocalDataSource, 
    mapper: bookMapper,
    reviewRepository: reviewRepository, 
  );
  
  // Inicializa a Store com o Repositório
  bookStore = BookStore(repository: bookRepository);

  isDependenciesInitialized = true;
}

// CRÍTICO: main() agora é ASYNC e AGUARDA a inicialização antes do runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // CRÍTICO: AGUARDA o Future antes de chamar runApp
    await initDependencies(); 
  } catch (e) {
    // Se a inicialização falhar (conexão/SharedPreferences), exibe erro
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Erro Fatal de Inicialização: ${e.toString()}', 
            style: const TextStyle(color: Colors.red)),
        ),
      ),
    ));
    return;
  }
  
  // Se a inicialização foi bem-sucedida, injeta o Provider e a RootApp
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BookStore>(create: (context) => bookStore),
        // NOVO: Injeta o ProfileController
        ChangeNotifierProvider<ProfileController>(create: (context) => profileController), 
      ],
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