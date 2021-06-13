import 'package:flutter/cupertino.dart';

class SubjectModel {
  final String id;
  final String name;
  final double credits;
  final double hours;
  final String desc;
  final List<String> teachersIds;

  SubjectModel({
    @required this.id,
    @required this.name,
    @required this.credits,
    @required this.desc,
    @required this.hours,
    this.teachersIds,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      credits: map['credits'] as double,
      hours: map['hours'] as double,
      desc: map['desc'] as String,
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
