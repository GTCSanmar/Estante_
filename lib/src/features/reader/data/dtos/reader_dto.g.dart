// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReaderDto _$ReaderDtoFromJson(Map<String, dynamic> json) => ReaderDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  isActive: json['isActive'] as bool?,
  memberSince: json['memberSince'] as String?,
  passwordHash: json['passwordHash'] as String?,
);

Map<String, dynamic> _$ReaderDtoToJson(ReaderDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'isActive': instance.isActive,
  'memberSince': instance.memberSince,
  'passwordHash': instance.passwordHash,
};
