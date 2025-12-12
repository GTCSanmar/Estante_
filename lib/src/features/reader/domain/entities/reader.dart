// lib/src/features/reader/domain/entities/reader.dart
// Entidade de Domínio: define o objeto Leitor/Usuário
class Reader {
  // Tipagem forte e invariantes de domínio
  final String id;
  final String name;
  final String email;
  final bool isActive;
  final DateTime memberSince;
  final String? passwordHash; // Hash da senha (invariante de segurança)

  Reader({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.memberSince,
    this.passwordHash,
  });

  // Validação de domínio simples
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Método copyWith para operações de atualização
  Reader copyWith({
    String? id,
    String? name,
    String? email,
    bool? isActive,
    DateTime? memberSince,
    String? passwordHash,
  }) {
    return Reader(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      memberSince: memberSince ?? this.memberSince,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}