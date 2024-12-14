// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserTestImpl _$$UserTestImplFromJson(Map<String, dynamic> json) =>
    _$UserTestImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$UserTestImplToJson(_$UserTestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
    };
