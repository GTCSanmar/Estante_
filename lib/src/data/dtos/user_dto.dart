
class UserDto {
  final String user_id;
  final String full_name;
  final String email;

  UserDto({
    required this.user_id,
    required this.full_name,
    required this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      user_id: json['user_id'] as String,
      full_name: json['full_name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'full_name': full_name,
      'email': email,
    };
  }
}