import 'dart:io';

// Contrato para as operações de perfil (dados básicos e foto).
abstract class ProfileRepository {
  // Dados básicos (existentes no SharedPreferences)
  String getUserName();
  String getUserEmail();

  // Operações de Foto de Perfil
  Future<String?> getPhotoPath(); // Obtém o caminho local da foto
  
  // Define a foto (salvando o arquivo e atualizando o metadado)
  // Retorna o novo caminho local em caso de sucesso.
  Future<String> setPhoto(File imageFile); 
  
  // Remove a foto (apaga o arquivo e limpa o metadado)
  Future<void> removePhoto(); 
}