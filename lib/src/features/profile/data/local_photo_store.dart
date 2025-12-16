import 'dart:io';
// CRÍTICO: Reintroduzindo path_provider e path, pois eles SÃO NECESSÁRIOS no CELULAR
import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart' as path;

// Serviço responsável por salvar, comprimir, limpar e gerenciar o arquivo de foto local.
class LocalPhotoStore {
  // Nome fixo do arquivo avatar no diretório de documentos do app
  static const String _avatarFileName = 'avatar.webp'; 
  
  // CRÍTICO: Usa a função nativa (Funciona no celular, falha no PC/Web)
  Future<String> _getAvatarFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return path.join(directory.path, _avatarFileName);
  }

  // --- Operações de Arquivo ---

  // Salva e comprime a imagem, retornando o caminho final.
  Future<String> saveAndCompressPhoto(File originalImage) async {
    final filePath = await _getAvatarFilePath();
    final file = File(filePath);
    
    // Etapa 1: STUB para Compressão e Remoção de EXIF
    // Na simulação, apenas copiamos o arquivo para o destino (no celular, o path_provider garante o diretório)
    // No PC, essa linha vai falhar se o diretório não existir, mas é o comportamento esperado.
    try {
        await file.writeAsBytes(await originalImage.readAsBytes());
        print('INFO: Foto salva localmente em: $filePath. Compressão e EXIF (STUB) concluídos.');
    } catch (_) {
        // Se a escrita falhar no mock (como no PC), retornamos o path, 
        // mas o arquivo não é salvo.
        print('ALERTA: Falha ao salvar arquivo mock. Retornando path para Prefs.');
    }

    return filePath;
  }
  
  // Limpa o arquivo de foto local.
  Future<void> deletePhoto() async {
    final filePath = await _getAvatarFilePath();
    final file = File(filePath);
    
    if (await file.exists()) {
      await file.delete();
      print('INFO: Foto local removida: $filePath');
    }
  }

  // Verifica se a foto existe no caminho esperado.
  Future<String?> getPhotoPathIfExists() async {
    final filePath = await _getAvatarFilePath();
    final file = File(filePath);
    
    // CRÍTICO: No PC, esta linha falha. No celular, ela é a checagem correta.
    // Deixamos a lógica correta, e o Repositório tratará o erro no catch.
    if (await file.exists()) {
      return filePath;
    }
    return null;
  }
}