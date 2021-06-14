import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/subject_model.dart';

class SubjectService {
  final _subjectsCollection = 'subjects';

  CollectionReference get collectionPath {
    return FirebaseFirestore.instance.collection(_subjectsCollection);
  }


  Future<void> addSubject(
      String name, String desc, double credits, double hours) {
    // collectionPath.doc().collection('subjects');
    // final List<SubjectModel> subject = [];
    // subject.where((e) => e.teachersIds.contains(currentUser.id)).toList();
    // users.where((e) => subkect.teachersIds.containers(e.id)).toList();

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

  Future<void> deleteSubject(String docId) {
    return collectionPath
        .doc(docId)
        .delete()
        .then((value) => print("Subject Deleted"))
        .catchError((error) => print("Failed to delete subject: $error"));
  }

  Stream<QuerySnapshot<Object>> getSubjects() {
    return collectionPath.snapshots(includeMetadataChanges: true);
  }
}
