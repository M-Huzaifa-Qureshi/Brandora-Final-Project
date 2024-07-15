import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_entity.g.dart';
@JsonSerializable()
class userEntity {
  String? userId;
  String? email;
  String? userName;
  userEntity({
    required this.userId,
    required this.email,
    required this.userName,
  });
  factory userEntity.fromJson(Map<String, dynamic> json) =>
      _$userEntityFromJson(json);
  Map<String, dynamic> toJson() => _$userEntityToJson(this);
  static CollectionReference<userEntity> collection() {
    return FirebaseFirestore.instance
        .collection('userEntity')
        .withConverter<userEntity>(
            fromFirestore: (snapshot, _) =>
                userEntity.fromJson(snapshot.data()!),
            toFirestore: (student, _) => student.toJson());
  }
  static DocumentReference<userEntity> doc({required String userId}) {
    return FirebaseFirestore.instance
        .collection("userEntity")
        .doc(userId)
        .withConverter<userEntity>(
            fromFirestore: (snapshot, _) =>
                userEntity.fromJson(snapshot.data()!),
            toFirestore: (student, _) => student.toJson());
  }
}
