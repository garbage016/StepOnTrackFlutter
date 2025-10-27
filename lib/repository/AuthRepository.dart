import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthResult {
  final bool success;
  final String? error;

  AuthResult({required this.success, this.error});
}

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AuthResult> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return AuthResult(success: false, error: 'Email o password vuoti');
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "Utente non registrato";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Email o password errati";
      } else {
        errorMessage = e.message ?? "Errore sconosciuto";
      }
      return AuthResult(success: false, error: errorMessage);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<AuthResult> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<void> saveUserData({
    required String nome,
    required String cognome,
    required String username,
    required String dataNascita,
    required String email,
    required String password,
  }) async {
    final userData = {
      'nome': nome,
      'cognome': cognome,
      'username': username,
      'dataNascita': dataNascita,
      'email': email,
      'password': password,
      'dataCreazione': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Utente').doc(username).set(userData);
  }

  Future<bool> controlloUsername(String username) async {
    try {
      final doc = await _firestore.collection('Utente').doc(username).get();
      return !doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? currentUser() => _auth.currentUser;
}
