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
  String? regionId;
  String? districtId;

  PharmacyModel({
    this.id,
    this.name,
    this.address,
    this.about,
    this.timeTable,
    this.phone,
    this.lat,
    this.long,
    this.regionId,
    this.districtId,
  });

  PharmacyModel.fromJson(QueryDocumentSnapshot json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    about = json['about'];
    timeTable = json['time_table'];
    phone = json['phone'];
    lat = json['lat'];
    long = json['long'];
    regionId = json['regionId'];
    districtId = json['districtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['about'] = about;
    data['time_table'] = timeTable;
    data['phone'] = phone;
    data['lat'] = lat;
    data['long'] = long;
    data['regionId'] = regionId;
    data['districtId'] = districtId;
    return data;
  }
}
