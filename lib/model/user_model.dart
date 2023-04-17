import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? name;
  String? surname;
  String? email;
  String? avatar;
  String? password;

  UserData({this.name, this.surname, this.email, this.avatar, this.password});

  UserData.fromJson(QueryDocumentSnapshot json) {
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    // avatar = json['avatar'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['password'] = this.password;
    return data;
  }
}
