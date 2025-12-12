// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorDto _$AuthorDtoFromJson(Map<String, dynamic> json) => AuthorDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
  biography: json['biography'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$AuthorDtoToJson(AuthorDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'biography': instance.biography,
  'createdAt': instance.createdAt,
};
