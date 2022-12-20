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
  String? ns10;
  String? ns11;
  String? lat;
  String? long;
  String? role;

  DoctorModel(
      {this.id,
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
        this.ns10,
        this.ns11,
        this.role,
        this.lat,
        this.long});

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
    ns10 = json['ns10'];
    ns11 = json['ns11'];
    lat = json['lat'];
    long = json['long'];
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
    data['ns10'] = this.ns10;
    data['ns11'] = this.ns11;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['role'] = this.role;
    return data;
  }
}
