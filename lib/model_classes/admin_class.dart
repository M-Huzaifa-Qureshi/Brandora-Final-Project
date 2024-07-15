import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'admin_class.g.dart';
@JsonSerializable()
class AdminEntity{
  String? adminId;
  String? adminName;
  String? email;
  AdminEntity(
      {this.adminId,
        this.adminName,
        this.email,
      });
  factory AdminEntity.fromJson(Map<String, dynamic> json) =>
      _$AdminEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AdminEntityToJson(this);
  static CollectionReference<AdminEntity> collection() {
    return FirebaseFirestore.instance
        .collection('adminEntity')
        .withConverter<AdminEntity>(
        fromFirestore: (snapshot, _) =>
            AdminEntity.fromJson(snapshot.data()!),
        toFirestore: (student, _) => student.toJson());
  }
  static DocumentReference<AdminEntity> doc({required String adminId}) {
    return FirebaseFirestore.instance
        .doc('adminEntity/$adminId')
        .withConverter<AdminEntity>(
        fromFirestore: (snapshot, _) => AdminEntity.fromJson(snapshot.data()!),
        toFirestore: (student, _) => student.toJson());
  }
}