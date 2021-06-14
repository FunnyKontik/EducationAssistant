import 'package:flutter/cupertino.dart';

class SubjectModel {
  final String id;
  final String name;
  final int credits;
  final int hours;
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
        credits: map['credits'] as int,
        hours: map['hours'] as int,
        desc: map['desc'] as String,
        teachersIds: (map['teacherIds'] as List)
            .map((e) => e as String)
            .toList());
  }

  SubjectModel copyWith({
    String id,
    String name,
    int credits,
    int hours,
    String desc,
    List<String> teachersIds,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (credits == null || identical(credits, this.credits)) &&
        (hours == null || identical(hours, this.hours)) &&
        (desc == null || identical(desc, this.desc)) &&
        (teachersIds == null || identical(teachersIds, this.teachersIds))) {
      return this;
    }
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      hours: hours ?? this.hours,
      desc: desc ?? this.desc,
      teachersIds: teachersIds ?? this.teachersIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'credits': credits,
      'hours': hours,
      'teacherIds': teachersIds,
    };
  }
}
