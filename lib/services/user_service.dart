import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
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
}
