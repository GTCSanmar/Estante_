// lib/src/data/daos/reading_goal_dao.dart

import 'package:estante/src/domain/entities/reading_goal.dart';

abstract class ReadingGoalDao {
  // 1. CREATE (Criar)
  // Insere uma nova meta no banco de dados.
  Future<void> insertGoal(ReadingGoalDto goal);

  // 2. READ (Ler) - Por ID
  // Retorna uma meta específica.
  Future<ReadingGoalDto?> getGoalById(String id);

  // 3. READ (Ler) - Todas
  // Retorna todas as metas (ex: para uma lista de histórico).
  Future<List<ReadingGoalDto>> getAllGoals();

  // 4. UPDATE (Atualizar)
  // Atualiza uma meta existente.
  Future<void> updateGoal(ReadingGoalDto goal);

  // 5. DELETE (Excluir)
  // Remove uma meta pelo ID.
  Future<void> deleteGoal(String id);

  // 6. QUERY Específica (Exemplo: Meta Anual)
  // Retorna a meta ativa (ou para o período atual).
  Future<ReadingGoalDto?> getActiveGoal();
}