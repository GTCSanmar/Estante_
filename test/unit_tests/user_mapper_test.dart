import 'package:flutter_test/flutter_test.dart';
import 'package:estante/src/data/dtos/user_dto.dart'; // VERIFIQUE O NOME DO SEU PACOTE AQUI
import 'package:estante/src/data/mappers/user_mapper.dart';
import 'package:estante/src/domain/entities/user.dart';

void main() {
  group('UserMapper', () {
    test('should correctly map UserDto to User Entity', () {
      final userDto = UserDto(
        user_id: '123-abc', 
        full_name: 'Gabriel Teste', 
        email: 'gabriel.teste@email.com',
      );

      final userEntity = UserMapper.toEntity(userDto);

      expect(userEntity, isA<User>());
      expect(userEntity.id, userDto.user_id); 
      expect(userEntity.name, userDto.full_name); 
    });

    test('should correctly map User Entity to UserDto', () {
      final userEntity = User(
        id: '456-def',
        name: 'Maria User',
        email: 'maria.user@email.com',
      );

      final userDto = UserMapper.toDto(userEntity);

      expect(userDto, isA<UserDto>());
      expect(userDto.user_id, userEntity.id); // <--- CORRIGIDO: user_id
      expect(userDto.full_name, userEntity.name); // <--- CORRIGIDO: full_name
    });
  });
}