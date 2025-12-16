import 'dart:io';
import 'package:flutter/material.dart';
import 'package:estante/src/features/profile/domain/repositories/profile_repository.dart';

// Este controller gerencia o estado do perfil na UI (nome, email, e caminho da foto).
class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository;

  // Estado
  String _userName = '';
  String _userEmail = '';
  String? _photoPath; // Caminho local do arquivo

  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get photoPath => _photoPath;

  // Indica se o caminho da foto está sendo carregado (para evitar travar a UI)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileController({required ProfileRepository repository}) : _repository = repository {
    _loadProfileData();
  }

  // Carrega os dados básicos e o caminho da foto na inicialização
  Future<void> _loadProfileData() async {
    _isLoading = true;
    _userName = _repository.getUserName();
    _userEmail = _repository.getUserEmail();
    
    // Tenta obter o caminho da foto (que já faz a validação de arquivo)
    _photoPath = await _repository.getPhotoPath();

    _isLoading = false;
    notifyListeners();
  }

  // --- Operações de Set/Remove (Invocadas pelo fluxo de seleção de UI) ---

  // Define uma nova foto (chamado após a seleção/compressão no fluxo da UI)
  Future<void> setPhoto(File imageFile) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newPath = await _repository.setPhoto(imageFile);
      _photoPath = newPath;
      
    } catch (e) {
      // Em caso de erro (compressão/armazenamento), o path será null
      print('ERRO ao definir foto: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove a foto
  Future<void> removePhoto() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.removePhoto();
      _photoPath = null;
      
    } catch (e) {
      print('ERRO ao remover foto: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retorna as iniciais do usuário para o fallback
  String getInitials() {
    if (_userName.isEmpty) return 'U'; // Usuário
    final parts = _userName.trim().split(' ');
    String initials = '';
    
    // Pega a primeira letra do primeiro nome
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initials += parts[0][0];
    }
    // Pega a primeira letra do último nome, se existir
    if (parts.length > 1 && parts.last.isNotEmpty) {
      initials += parts.last[0];
    }
    
    return initials.toUpperCase();
  }
}