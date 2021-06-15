import 'package:flutter/cupertino.dart';

class GroupModel {
  final String id;
  final String name;
  final List<String> subjectsIds;
  final List<String> usersIds;

  const GroupModel({
    @required this.id,
    @required this.name,
    this.subjectsIds = const [''],
    this.usersIds = const [''],
  });

  GroupModel copyWith({
    String id,
    String name,
    List<String> subjectsIds,
    List<String> usersIds,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (subjectsIds == null || identical(subjectsIds, this.subjectsIds)) &&
        (usersIds == null || identical(usersIds, this.usersIds))) {
      return this;
    }
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subjectsIds: subjectsIds ?? this.subjectsIds,
      usersIds: usersIds ?? this.usersIds,
    );
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        id: map['id'] as String,
        name: map['name'] as String,
        subjectsIds:
            (map['subjectsIds'] as List).map((e) => e as String).toList(),
        usersIds: (map['usersIds'] as List).map((e) => e as String).toList());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subjectsIds': subjectsIds,
      'usersIds': usersIds,
    };
  }
}
