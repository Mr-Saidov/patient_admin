import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyModel {
  String? id;
  String? name;
  String? address;
  String? about;
  String? timeTable;
  String? phone;
  String? lat;
  String? long;

  PharmacyModel(
      {this.id,
        this.name,
        this.address,
        this.about,
        this.timeTable,
        this.phone,
        this.lat,
        this.long});

  PharmacyModel.fromJson(QueryDocumentSnapshot json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    about = json['about'];
    timeTable = json['time_table'];
    phone = json['phone'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['about'] = this.about;
    data['time_table'] = this.timeTable;
    data['phone'] = this.phone;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
