import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  final String id;
  final String name;
  final String imageUrl;
  final String email;
  final UserRole role;
  final String groupId;

  UserModel({
    @required this.imageUrl,
    @required this.name,
    @required this.email,
    @required this.role,
    @required this.groupId,
    this.id,
  });

  bool get isAdmin => role == UserRole.admin;

  UserModel copyWith({
    String id,
    String name,
    String imageUrl,
    String email,
    UserRole role,
    String groupId,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (imageUrl == null || identical(imageUrl, this.imageUrl)) &&
        (email == null || identical(email, this.email)) &&
        (role == null || identical(role, this.role)) &&
        (groupId == null || identical(groupId, this.groupId))) {
      return this;
    }
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      role: role ?? this.role,
      groupId: groupId ?? this.groupId,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: _roleFromString(map['role']),
      groupId: map['groupId'] as String,
    );
  }

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      imageUrl: firebaseUser.photoURL,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      role: UserRole.user,
      groupId: '',
    );
  }

  static UserRole _roleFromString(String text) {
    switch (text) {
      case 'admin':
        return UserRole.admin;
      case 'moder':
        return UserRole.moder;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl ?? '',
      'name': name ?? 'Default user',
      'email': email,
      'role': role.asString,
      'groupId': groupId,
    };
  }
}
