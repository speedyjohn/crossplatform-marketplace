import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserData(user.uid);
    });
  }

  Future<AppUser?> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc.data()!, uid);
    }
    return null;
  }

  Future<AppUser?> registerWithEmail(
      String email,
      String password,
      String name,
      String? address,
      String? phone,
      ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = AppUser(
        uid: credential.user!.uid,
        email: email,
        name: name,
        address: address,
        phone: phone,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toFirestore());

      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<AppUser?> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getUserData(credential.user!.uid);
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateUserPreferences(
      String uid, {
        String? theme,
        String? language,
      }) async {
    final updateData = <String, dynamic>{};
    if (theme != null) updateData['theme'] = theme;
    if (language != null) updateData['language'] = language;

    await _firestore.collection('users').doc(uid).update(updateData);
  }
}