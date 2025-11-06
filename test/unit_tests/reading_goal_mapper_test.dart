// 1. Importação da Biblioteca de Teste
import 'package:flutter_test/flutter_test.dart';

// 2. Importações Corrigidas (Verifique o nome do pacote e o caminho)
// Entidade ReadingGoal: lib/src/domain/entities/reading_goal.dart
import 'package:estante/domain/entities/reading_goal.dart';

// DTO ReadingGoalDto: lib/src/data/dtos/reading_goal_dto.dart
import 'package:estante/src/data/dtos/reading_goal_dto.dart'; 

// 3. Importação do MAPPER (Verifique o caminho)
// Mapper: lib/src/data/mappers/reading_goal_mapper.dart
import 'package:estante/src/data/dtos/reading_goal_dto.dart'; 


void main() {
  // EXEMPLOS MOCKADOS PARA TESTAR
  final mockEntity = ReadingGoal(
    // Adicione os campos necessários da sua entidade aqui
    id: '1',
    goal: 5,
    current: 2,
    date: DateTime(2025, 1, 1),
  );

  final mockDto = ReadingGoalDto(
    // Adicione os campos necessários do seu DTO aqui
    id: '1',
    goal: 5,
    current: 2,
    date: DateTime(2025, 1, 1).toIso8601String(), // DTOs costumam ter datas como String
  );

  group('ReadingGoalMapper', () {
    
    // Testa a conversão de DTO para Entidade
    test('toEntity deve converter ReadingGoalDto para a entidade ReadingGoal', () {
      final entity = ReadingGoalMapper.toEntity(mockDto);

      expect(entity.id, mockDto.id);
      expect(entity.goal, mockDto.goal);
      expect(entity.current, mockDto.current);
      // Você pode precisar de uma lógica de comparação de datas mais robusta aqui
      // expect(entity.date.toIso8601String(), mockDto.date); 
    });

    // Testa a conversão de Entidade para DTO
    test('toDto deve converter a entidade ReadingGoal para ReadingGoalDto', () {
      final dto = ReadingGoalMapper.toDto(mockEntity);

      expect(dto.id, mockEntity.id);
      expect(dto.goal, mockEntity.goal);
      expect(dto.current, mockEntity.current);
      // Você pode precisar de uma lógica de comparação de datas mais robusta aqui
      // expect(dto.date, mockEntity.date.toIso8601String());
    });
  });
}