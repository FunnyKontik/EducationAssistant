import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/subject_model.dart';

class SubjectService {
  final _subjectsCollection = 'subjects';

  CollectionReference get collectionPath {
    return FirebaseFirestore.instance.collection(_subjectsCollection);
  }

  Future<void> addTeacher(SubjectModel subject, String teacherId){
    subject.teachersIds.add(teacherId);
    return collectionPath
        .doc(subject.id)
        .update({'TeacherIds': subject.teachersIds})
        .then((value) => print('Subject teachers updated'))
        .catchError((error) => print('Failed to update subject teacher: $error'));
  }

  Future<void> addSubject(
      String name, String desc, double credits, double hours) {
    // collectionPath.doc().collection('subjects');
    // final List<SubjectModel> subject = [];
    // subject.where((e) => e.teachersIds.contains(currentUser.id)).toList();
    // users.where((e) => subject.teachersIds.containers(e.id)).toList();

    // Call the user's CollectionReference to add a new user
    return collectionPath
        .add({
          'name': name,
          'desc': desc,
          'credits': credits,
          'hours': hours,
        })
        .then((value) => print("Subject Added"))
        .catchError((error) => print("Failed to add subject: $error"));
  }

  Future<void> deleteSubject(SubjectModel subject) {
    try {
      return collectionPath.doc(subject.id).delete();
    } catch (e, s) {
      print('deleteGroupFromFirestore: $e, $s');
    }
  }



  Stream<List<SubjectModel>> getSubjects() {
    try {
      return collectionPath.snapshots(includeMetadataChanges: true).map((e) => e
          .docs
          .map((e) => SubjectModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e, s) {
      return null;
    }
  }
}
