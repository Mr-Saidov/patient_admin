import 'package:cloud_firestore/cloud_firestore.dart';

class DrugModel {
  String? id;
  String? name;
  String? drugTypeId;
  String? drugTypeName;
  String? using;
  String? country;
  String? activeIngredient;
  String? numberOfPackages;
  String? expireDate;

  DrugModel({
    this.id,
    this.name,
    this.drugTypeId,
    this.drugTypeName,
    this.using,
    this.country,
    this.activeIngredient,
    this.numberOfPackages,
    this.expireDate,
  });

  DrugModel.fromJson(QueryDocumentSnapshot json) {
    id = json['id'];
    name = json['name'];
    drugTypeId = json['drugTypeId'];
    drugTypeName = json['drugTypeName'];
    using = json['using'];
    country = json['country'];
    activeIngredient = json['activeIngredient'];
    numberOfPackages = json['numberOfPackages'];
    expireDate = json['expireDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['drugTypeId'] = this.drugTypeId;
    data['drugTypeName'] = this.drugTypeName;
    data['using'] = this.using;
    data['country'] = this.country;
    data['activeIngredient'] = this.activeIngredient;
    data['numberOfPackages'] = this.numberOfPackages;
    data['expireDate'] = this.expireDate;
    return data;
  }
}
