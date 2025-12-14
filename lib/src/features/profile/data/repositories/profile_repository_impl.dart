import 'dart:io';
import 'package:estante/src/shared/services/prefs_service.dart';
import 'package:estante/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:estante/src/features/profile/data/local_photo_store.dart';

// Implementação que conecta o armazenamento de arquivos (LocalPhotoStore) 
// com o armazenamento de metadados (PrefsService).
class ProfileRepositoryImpl implements ProfileRepository {
  final PrefsService preferencesService;
  final LocalPhotoStore photoStore;

  ProfileRepositoryImpl({
    required this.preferencesService,
    required this.photoStore,
  });

  // --- Dados Básicos (Mocks) ---
  @override
  String getUserName() => preferencesService.getUserName();
  
  @override
  String getUserEmail() => preferencesService.getUserEmail();

  // --- Operações de Foto ---
  
  @override
  Future<String?> getPhotoPath() async {
    // 1. Tenta ler o caminho da foto do SharedPreferences (Metadado)
    final path = preferencesService.getUserPhotoPath();
    
    if (path == null) {
      return null;
    }

    try {
      // CRÍTICO: Tenta verificar a existência do arquivo. Se for um mock não-existente, 
      // ou se o File.exists() falhar, o catch tratará o erro.
      final file = File(path);
      
      // 2. Tenta verificar se o caminho armazenado realmente aponta para um arquivo que existe.
      // Se não existir, ou se o caminho for inválido (como nosso mock no web), isso deve falhar.
      if (await file.exists()) {
        return path;
      }
      
      // Se o arquivo não existir (e o path não for null)
      print('ALERTA: Path salvo no Prefs ($path) não existe no disco. Limpando metadados.');
      await preferencesService.clearUserPhotoPath();
      await preferencesService.clearUserPhotoUpdatedAt();
      return null;

    } on PathNotFoundException catch (_) {
      // 3. TRATAMENTO EXPLÍCITO DO ERRO: Se o caminho for inválido ou não for encontrado (seu erro!)
      // Isso ocorre com mock paths. Neste caso, limpamos e retornamos nulo.
      print('ERRO: Falha crítica na leitura do arquivo ($path). O caminho é inválido. Limpando Prefs.');
      await preferencesService.clearUserPhotoPath();
      await preferencesService.clearUserPhotoUpdatedAt();
      return null;
      
    } catch (e) {
      // 4. Tratamento de outros erros (permissão, etc.)
      print('ERRO GENÉRICO ao verificar foto: $e. Limpando Prefs.');
      await preferencesService.clearUserPhotoPath();
      await preferencesService.clearUserPhotoUpdatedAt();
      return null;
    }
  }

  @override
  Future<String> setPhoto(File imageFile) async {
    // 1. Salva/Comprime o arquivo e obtém o caminho local
    final filePath = await photoStore.saveAndCompressPhoto(imageFile);

    // 2. Salva o metadado no SharedPreferences
    await preferencesService.setUserPhotoPath(filePath);
    await preferencesService.setUserPhotoUpdatedAt(DateTime.now().millisecondsSinceEpoch);

    return filePath;
  }

  @override
  Future<void> removePhoto() async {
    // 1. Apaga o arquivo físico
    await photoStore.deletePhoto();

    // 2. Limpa o metadado no SharedPreferences
    await preferencesService.clearUserPhotoPath();
    await preferencesService.clearUserPhotoUpdatedAt();
  }
}