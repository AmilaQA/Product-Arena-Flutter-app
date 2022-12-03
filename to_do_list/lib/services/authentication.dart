import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({required this.auth});

  //dobavljenje usera sa firebase-a
  Stream<User?> get user => auth.authStateChanges();

  Future<String> createAccount(
      {required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.email.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      rethrow;
    }
  }
}
