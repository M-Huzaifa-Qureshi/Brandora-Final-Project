import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'checkout_model.g.dart';
@JsonSerializable()
class Check {
  final List selectedItem;
  String? name;
  String? address;
  String? contactNo;
  String? nicImage;
  String? email;
  String?checkID;
  Check(
      {required this.selectedItem,
      this.name,
       this.checkID,
      this.address,
      this.contactNo,
      this.email,
      this.nicImage});
  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);
  Map<String, dynamic> toJson() => _$CheckToJson(this);
  static CollectionReference<Check> collection() {
    return FirebaseFirestore.instance
        .collection('checkoutEntity')
        .withConverter<Check>(
            fromFirestore: (snapshot, _) => Check.fromJson(snapshot.data()!),
            toFirestore: (student, _) => student.toJson());
  }

  static DocumentReference<Check> doc({required String checkId}) {
    return FirebaseFirestore.instance
        .collection("checkoutEntity")
        .doc(checkId)
        .withConverter<Check>(
            fromFirestore: (snapshot, _) => Check.fromJson(snapshot.data()!),
            toFirestore: (student, _) => student.toJson());
  }
}
