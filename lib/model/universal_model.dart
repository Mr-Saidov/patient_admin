import 'package:cloud_firestore/cloud_firestore.dart';

class UniversalModel {
  String? id;
  String? name;
  bool isSelected = false;

  UniversalModel({this.id, this.name});

  UniversalModel.fromJson(QueryDocumentSnapshot json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
