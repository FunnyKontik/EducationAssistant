import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersService {
  final _usersCollection = 'users';

  CollectionReference get collectionPath {
    return FirebaseFirestore.instance.collection(_usersCollection);
  }

  Future<UserModel> findUserWithUid(String uid) async {
    try {
      final document = await collectionPath.doc(uid).get();
      final data = document.data() as Map<String, dynamic>;
      if (data?.isEmpty ?? true) return null;
      return UserModel.fromMap(data).copyWith(id: document.id);
    } catch (e, s) {
      print('findUserWithUid: $e, $s');
      return Future.error(e);
    }
  }

  Future<UserModel> createUser(User firebaseUser) async {
    try {
      final user = UserModel.fromFirebaseUser(firebaseUser);
      await collectionPath.doc(user.id).set(user.toMap());
      return user;
    } catch (e, s) {
      print('saveUserToFirestore: $e, $s');
      return Future.error(e);
    }
  }


  Stream<List<UserModel>> getAllUsers() {
    try {
      return collectionPath.snapshots(includeMetadataChanges: true).map((e) => e
          .docs
          .map((e) => UserModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e, s) {
      return null;
    }
  }

  Future<void> deleteUser(String docId) {
    return collectionPath
        .doc(docId)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to delete user: $error'));
  }

  Future<void> updateUserToModer(String userID) {
    return collectionPath
        .doc(userID)
        .update({'role': 'moder'})
        .then((value) => print('User Updated'))
        .catchError((error) => print('Failed to update user: $error'));
  }

  Future<void> updateModerToUser(String userID) {
    return collectionPath
        .doc(userID)
        .update({'role': 'user'})
        .then((value) => print('User Updated'))
        .catchError((error) => print('Failed to update user: $error'));
  }
}
