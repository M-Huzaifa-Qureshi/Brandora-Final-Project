import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pics_entity.g.dart';

@JsonSerializable()
class PicsEntity {
  String? image;
  String? name;
  double? price;
  String? descController;
  int? quantity;
  String? userId;

  PicsEntity(
      {
      this.userId,
      this.quantity,
      this.descController,
      this.image,
      this.name,
      this.price});

  factory PicsEntity.fromJson(Map<String, dynamic> json) => _$PicsEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PicsEntityToJson(this);

  static CollectionReference<PicsEntity> collection() {
    return FirebaseFirestore.instance
        .collection('picsEntity')
        .withConverter<PicsEntity>(
            fromFirestore: (snapshot, _) =>
                PicsEntity.fromJson(snapshot.data()!),
            toFirestore: (student, _) => student.toJson());
  }

  static DocumentReference<PicsEntity> doc({required String picsId}) {
    return FirebaseFirestore.instance
        .collection("picsEntity")
        .doc(picsId)
        .withConverter<PicsEntity>(
            fromFirestore: (snapshot, _) =>
                PicsEntity.fromJson(snapshot.data()!),
            toFirestore: (student, _) => student.toJson());
  }
}
