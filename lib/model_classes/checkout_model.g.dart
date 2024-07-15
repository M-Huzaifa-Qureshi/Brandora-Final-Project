// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Check _$CheckFromJson(Map<String, dynamic> json) => Check(
      selectedItem: json['selectedItem'] as List<dynamic>,
      name: json['name'] as String?,
      checkID: json['checkID'] as String?,
      address: json['address'] as String?,
      contactNo: json['contactNo'] as String?,
      email: json['email'] as String?,
      nicImage: json['nicImage'] as String?,
    );

Map<String, dynamic> _$CheckToJson(Check instance) => <String, dynamic>{
      'selectedItem': instance.selectedItem,
      'name': instance.name,
      'address': instance.address,
      'contactNo': instance.contactNo,
      'nicImage': instance.nicImage,
      'email': instance.email,
      'checkID': instance.checkID,
    };
