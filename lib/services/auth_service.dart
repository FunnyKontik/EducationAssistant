import 'package:education_assistant/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _firebaseInstace = FirebaseAuth.instance;

  Future<UserModel> checkCurrentUser() async {
    try {
      final firebaseUser = _firebaseInstace.currentUser;
      if (firebaseUser != null) {
        return UserModel(
          imageUrl: firebaseUser.photoURL ?? '',
          name: firebaseUser.displayName,
          email: firebaseUser.email,
        );
      }
      print('User not found');
      return null;
    } catch (e, s) {
      print('error');
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

      await _firebaseInstace.signInWithCredential(credential);
      final user = await checkCurrentUser();
      print('Login Success');
      return user;
    } catch (e, s) {
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
