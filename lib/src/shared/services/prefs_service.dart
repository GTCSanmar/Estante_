import 'package:shared_preferences/shared_preferences.dart';
// REMOVIDO: Unused import: 'package:estante/src/shared/constants/app_routes.dart';

// O PrefsService gerencia todas as interações com o SharedPreferences.
// CRÍTICO: Esta é a única definição da classe PrefsService
class PrefsService {
  // CORREÇÃO: Usando late final. Permite inicialização posterior (no init()), mas apenas uma vez.
  late final SharedPreferences _prefs;

  // Chaves de Onboarding/Consentimento
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _privacyPolicyReadKey = 'privacy_policy_read';
  static const String _termsReadKey = 'terms_read';
  static const String _marketingConsentKey = 'marketing_consent';
  
  // CRÍTICO: Novas chaves para a foto de perfil
  static const String _userPhotoPathKey = 'user_photo_path';
  static const String _userPhotoUpdatedAtKey = 'user_photo_updated_at'; // Para cache

  PrefsService(); // Construtor sem argumentos para uso em late final

  // CRÍTICO: Função de inicialização assíncrona
  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs; // Associa a instância injetada (Agora permitido por 'late final')
  }
  
  // --- LGPD / Onboarding ---
  
  bool get getOnboardingCompleted => _prefs.getBool(_onboardingCompletedKey) ?? false;
  Future<void> setOnboardingCompleted(bool value) => _prefs.setBool(_onboardingCompletedKey, value);

  bool get getPrivacyPolicyRead => _prefs.getBool(_privacyPolicyReadKey) ?? false;
  Future<void> setPrivacyPolicyRead(bool value) => _prefs.setBool(_privacyPolicyReadKey, value);

  bool get getTermsRead => _prefs.getBool(_termsReadKey) ?? false;
  Future<void> setTermsRead(bool value) => _prefs.setBool(_termsReadKey, value);

  bool get getMarketingConsent => _prefs.getBool(_marketingConsentKey) ?? false;
  Future<void> setMarketingConsent(bool value) => _prefs.setBool(_marketingConsentKey, value);
  
  // --- NOVOS Métodos de Foto de Perfil (REQUERIDOS PELO REPOSITORY) ---

  // CRÍTICO: getPhotoPath()
  String? getUserPhotoPath() => _prefs.getString(_userPhotoPathKey);
  // CRÍTICO: setUserPhotoPath()
  Future<void> setUserPhotoPath(String path) => _prefs.setString(_userPhotoPathKey, path);
  // CRÍTICO: clearUserPhotoPath()
  Future<void> clearUserPhotoPath() => _prefs.remove(_userPhotoPathKey);

  // CRÍTICO: getUserPhotoUpdatedAt()
  int? getUserPhotoUpdatedAt() => _prefs.getInt(_userPhotoUpdatedAtKey);
  // CRÍTICO: setUserPhotoUpdatedAt()
  Future<void> setUserPhotoUpdatedAt(int timestamp) => _prefs.setInt(_userPhotoUpdatedAtKey, timestamp);
  // CRÍTICO: clearUserPhotoUpdatedAt()
  Future<void> clearUserPhotoUpdatedAt() => _prefs.remove(_userPhotoUpdatedAtKey);

  // --- Dados de Usuário (MOCK - REQUERIDOS PELO REPOSITORY) ---
  // CRÍTICO: getUserName()
  String getUserName() => 'Gabriel A. (Duque)'; 
  // CRÍTICO: getUserEmail()
  String getUserEmail() => 'gabriel.duque@estante.com'; 

}