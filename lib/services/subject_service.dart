import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectService {
  final _subjectsCollection = 'subjects';

  CollectionReference get collectionPath {
    return FirebaseFirestore.instance.collection(_subjectsCollection);
  }

  Future<SubjectModel> createSubject(SubjectModel firebaseSubject) async {
    try {
      final subject = SubjectModel.fromFirebaseSubject(firebaseSubject);
      await collectionPath.doc(subject.id).set(subject.toMap());
      return subject;
    } catch (e, s) {
      print('saveUserToFirestore: $e, $s');
      return Future.error(e);
    }
  }

  Future<void> deleteSubject(String docId) {
    return collectionPath
        .doc(docId)
        .delete()
        .then((value) => print("Subject Deleted"))
        .catchError((error) => print("Failed to delete subject: $error"));
  }

  Future<void> addSubject(String name, String desc, double credits, double hours) {
    // Call the user's CollectionReference to add a new user
    return collectionPath
        .add({
        'name': name,
        'desc':desc,
        'credits': credits,
        'hours':hours,
        })
        .then((value) => print("Subject Added"))
        .catchError((error) => print("Failed to add subject: $error"));
  }

  Stream<QuerySnapshot<Object>> getSubjects() {
    return collectionPath
        .snapshots(includeMetadataChanges: true);
  }
}