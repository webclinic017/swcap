// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.username,
    this.email,
    this.mobileNumber,
    this.password,
    this.lastLogin,
    this.isActive,
    this.publicIp,
    this.status,
    this.createdAt,
  });

  String id;
  String name;
  String username;
  String email;
  String mobileNumber;
  String password;
  String lastLogin;
  String isActive;
  String publicIp;
  String status;
  DateTime createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    mobileNumber: json["mobile_number"],
    password: json["password"],
    lastLogin: json["last_login"],
    isActive: json["is_active"],
    publicIp: json["public_ip"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "mobile_number": mobileNumber,
    "password": password,
    "last_login": lastLogin,
    "is_active": isActive,
    "public_ip": publicIp,
    "status": status,
    "created_at": createdAt.toIso8601String(),
  };
}
