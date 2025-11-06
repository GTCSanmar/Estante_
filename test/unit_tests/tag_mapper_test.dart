
import 'package:flutter_test/flutter_test.dart';
import 'package:estante/src/data/dtos/tag_dto.dart';
import 'package:estante/src/data/mappers/tag_mapper.dart';
import 'package:estante/src/domain/entities/tag.dart';

void main() {
  group('TagMapper', () {
    test('should correctly map TagDto to Tag Entity', () {
      final tagDto = TagDto(
        tag_id: 'cat-fic',
        tag_name: 'Ficção Científica',
      );

      final tagEntity = TagMapper.toEntity(tagDto);

      // 3. Verifica a conversão (Asserts)
      expect(tagEntity, isA<Tag>());
      expect(tagEntity.id, tagDto.tag_id);
      expect(tagEntity.name, tagDto.tag_name);
    });

    test('should correctly map Tag Entity to TagDto', () {
      final tagEntity = Tag(
        id: 'cat-progr',
        name: 'Programação',
      );

      final tagDto = TagMapper.toDto(tagEntity);

      expect(tagDto, isA<TagDto>());
      expect(tagDto.tag_id, tagEntity.id);
      expect(tagDto.tag_name, tagEntity.name);
    });
  });
}

