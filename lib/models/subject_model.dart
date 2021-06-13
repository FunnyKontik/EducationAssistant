import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SubjectModel {
  final String id;
  final String name;
  final double credits;
  final double hours;
  final String desc;

  SubjectModel(
      {@required this.id,
      @required this.name,
      @required this.credits,
      @required this.desc,
      @required this.hours});

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      credits: map['credits'] as double,
      hours: map['hours'] as double,
      desc: map['desc'] as String,
    );
  }

  factory SubjectModel.fromFirebaseSubject(SubjectModel firebasesubject) {
    return SubjectModel(
      id: firebasesubject.id,
      name: firebasesubject.name,
      desc: firebasesubject.desc,
      hours: firebasesubject.hours,
      credits: firebasesubject.credits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'credits': credits,
      'hours': hours,
    };
  }
}
