import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../views/home_view.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Stream<User?> get userChanges => _auth.authStateChanges();


  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registreerimine ebaõnnestus.';
    } catch (e) {
      return 'Tekkis viga: ${e.toString()}';
    }
  }


  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Sisselogimine ebaõnnestus.';
    } catch (e) {
      return 'Tekkis viga: ${e.toString()}';
    }
  }


  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Google sisselogimine katkestatud.';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Google sisselogimine ebaõnnestus.';
    } catch (e) {
      return 'Tekkis viga: ${e.toString()}';
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }


  Future<void> signOut(BuildContext context) async {
    await logout();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthView()),
    );
  }
}
