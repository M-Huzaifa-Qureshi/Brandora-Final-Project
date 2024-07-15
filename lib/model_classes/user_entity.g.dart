// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

userEntity _$userEntityFromJson(Map<String, dynamic> json) => userEntity(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$userEntityToJson(userEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'userName': instance.userName,
    };
