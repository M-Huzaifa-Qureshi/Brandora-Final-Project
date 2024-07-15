// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pics_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicsEntity _$PicsEntityFromJson(Map<String, dynamic> json) => PicsEntity(
      userId: json['userId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      descController: json['descController'] as String?,
      image: json['image'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PicsEntityToJson(PicsEntity instance) =>
    <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
      'price': instance.price,
      'descController': instance.descController,
      'quantity': instance.quantity,
      'userId': instance.userId,
    };
