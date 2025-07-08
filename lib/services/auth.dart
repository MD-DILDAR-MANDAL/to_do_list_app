import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:to_do_list_app/models/user_model.dart';

class Auth {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _firebaseUser(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(_firebaseUser);
  }

  Future<User?> handleSignInEmail(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user != null && !result.user!.emailVerified) {
      throw Exception(
        'Email not verified. Please check your inbox for the verification email.',
      );
    }

    return _firebaseUser(result.user);
  }

  Future<User?> handleSignUp(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user != null) {
      await result.user!.sendEmailVerification();
    }
    return _firebaseUser(result.user);
  }

  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }
}
