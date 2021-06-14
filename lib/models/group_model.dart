import 'package:flutter/cupertino.dart';

class GroupModel{

  final String id;
  final String name;
  final List<String> subjectsIds;
  final List<String> usersIds;

  GroupModel({
    @required this.id,
    @required this.name,
    this.subjectsIds,
    this.usersIds,
});

  GroupModel copyWith({
    String id,
    String name,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name))) {
      return this;
    }
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }





  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }



}