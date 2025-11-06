import '../../domain/entities/user.dart';
import '../dtos/user_dto.dart';

class UserMapper {
  static User toEntity(UserDto dto) {
    return User(
      id: dto.user_id,      
      name: dto.full_name,   
      email: dto.email,
    );
  }

  static UserDto toDto(User entity) {
    return UserDto(
      user_id: entity.id,      
      full_name: entity.name,   
      email: entity.email,
    );
  }
}