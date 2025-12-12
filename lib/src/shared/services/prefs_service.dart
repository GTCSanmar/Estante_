// lib/src/shared/services/prefs_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PrefsKeys {
  static const String onboardingCompleted = 'onboarding_completed';
  static const String privacyPolicyRead = 'privacy_policy_read';
  static const String termsRead = 'terms_read';
  static const String marketingConsent = 'marketing_consent';
}

class PrefsService {
  late SharedPreferences _prefs; 

  Future<void> init(SharedPreferences sharedPreferences) async {
    _prefs = sharedPreferences;
  }

  bool get getOnboardingCompleted => _prefs.getBool(PrefsKeys.onboardingCompleted) ?? false;
  bool get getPrivacyPolicyRead => _prefs.getBool(PrefsKeys.privacyPolicyRead) ?? false;
  bool get getTermsRead => _prefs.getBool(PrefsKeys.termsRead) ?? false;
  bool get getMarketingConsent => _prefs.getBool(PrefsKeys.marketingConsent) ?? false;

  Future<bool> setOnboardingCompleted(bool value) async {
    return _prefs.setBool(PrefsKeys.onboardingCompleted, value);
  }
  
  Future<bool> setPrivacyPolicyRead(bool value) async {
    return _prefs.setBool(PrefsKeys.privacyPolicyRead, value);
  }
  
  Future<bool> setTermsRead(bool value) async {
    return _prefs.setBool(PrefsKeys.termsRead, value);
  }

  Future<bool> setMarketingConsent(bool value) async {
    return _prefs.setBool(PrefsKeys.marketingConsent, value);
  }
}