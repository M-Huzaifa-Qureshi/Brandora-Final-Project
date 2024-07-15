// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminEntity _$AdminEntityFromJson(Map<String, dynamic> json) => AdminEntity(
      adminId: json['adminId'] as String?,
      adminName: json['adminName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AdminEntityToJson(AdminEntity instance) =>
    <String, dynamic>{
      'adminId': instance.adminId,
      'adminName': instance.adminName,
      'email': instance.email,
    };
