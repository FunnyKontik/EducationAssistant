import 'package:flutter/cupertino.dart';

class UserModel {

  final String name;
  final String imageUrl;
  final String email;

  UserModel({
    @required this.imageUrl,
    @required this.name,
    @required this.email,
});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'imageUrl': this.imageUrl,
      'name': this.name,
      'email': this.email,
    };
  }

}