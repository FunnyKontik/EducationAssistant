import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/models/subject_model.dart';

class GroupService {
  final _groupCollection = 'groups';

  CollectionReference get collectionPath {
    return FirebaseFirestore.instance.collection(_groupCollection);
  }

  Future<void> addGroup(String name) async {
    try {
      return collectionPath.add({
        'name': name,
      });
    } catch (e, s) {
      print('saveGroupToFirestore: $e, $s');
      return Future.error(e);
    }
  }

  Future<void> deleteGroup(GroupModel group) {
    try {
      return collectionPath.doc(group.id).delete();
    } catch (e, s) {
      print('deleteGroupFromFirestore: $e, $s');
    }
  }

  Stream<List<GroupModel>> getAllGroups() {
    try {
      return collectionPath.snapshots(includeMetadataChanges: true).map((e) => e
          .docs
          .map((e) => GroupModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e, s) {
      return null;
    }
  }
}
