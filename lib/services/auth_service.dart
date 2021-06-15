import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _userService = UsersService();
  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _firebaseInstance = FirebaseAuth.instance;

  Future<UserModel> checkCurrentUser() async {
    try {
      final firebaseUser = _firebaseInstance.currentUser;
      if (firebaseUser != null) {
        var user = await _userService.findUserWithUid(firebaseUser.uid);
        if (user == null) {
          print('New user: ${firebaseUser.uid}');
          return await _userService.createUser(firebaseUser);
        } else {
          print('User found: ${user.id}');
          return user;
        }
      }
      print('User not found');
      return null;
    } catch (e, s) {
      print('AuthService::checkCurrentUser: $e');
      return null;
    }
  }

  Future<UserModel> googleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      if (googleAuth == null) {
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseInstance.signInWithCredential(credential);
      final user = await checkCurrentUser();
      print('Login Success');
      return user;
    } catch (e, s) {
      print('Signing error');
      return null;
    }
  }

  Future<UserModel> firebaseRegistration(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseInstance.signInWithEmailAndPassword(
          email: email, password: password);
      final user = await checkCurrentUser();
      print('Login Success');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Signing error');
      return null;
    }
  }

  Future<UserModel> firebaseSignIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await checkCurrentUser();
      print('Login Success');
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      print('Signing error');
      return null;
    }
  }

  Future<bool> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      return true;
    } catch (e, s) {
      return false;
    }
  }
}
