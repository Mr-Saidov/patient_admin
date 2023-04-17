import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String? id;
  String? fullname;
  String? email;
  String? avatar;
  String? password;
  List<String>? profession;
  List<String>? language;
  String? experience;
  String? rating;
  String? birthYear;
  String? education;
  String? workHistory;
  String? bio;
  String? workTime;
  String? lat;
  String? long;
  String? role;
  String? regionId;
  String? districtId;

  DoctorModel({
    this.id,
    this.fullname,
    this.email,
    this.avatar,
    this.password,
    this.profession,
    this.language,
    this.experience,
    this.rating,
    this.birthYear,
    this.education,
    this.workHistory,
    this.bio,
    this.workTime,
    this.role,
    this.lat,
    this.long,
    this.regionId,
    this.districtId,
  });

  DoctorModel.fromJson(QueryDocumentSnapshot json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    avatar = json['avatar'];
    password = json['password'];
    profession = json['profession'].cast<String>();
    language = json['language'].cast<String>();
    experience = json['experience'];
    rating = json['rating'];
    birthYear = json['birthYear'];
    education = json['education'];
    workHistory = json['workHistory'];
    bio = json['bio'];
    workTime = json['workTime'];
    role = json['role'];
    lat = json['lat'];
    long = json['long'];
    regionId = json['regionId'];
    districtId = json['districtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['password'] = this.password;
    data['profession'] = this.profession;
    data['language'] = this.language;
    data['experience'] = this.experience;
    data['rating'] = this.rating;
    data['birthYear'] = this.birthYear;
    data['education'] = this.education;
    data['workHistory'] = this.workHistory;
    data['bio'] = this.bio;
    data['workTime'] = this.workTime;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['role'] = this.role;
    data['regionId'] = this.regionId;
    data['districtId'] = this.districtId;
    return data;
  }
}
