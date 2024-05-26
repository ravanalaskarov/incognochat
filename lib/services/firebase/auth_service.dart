import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/firebase_constants.dart';
import 'package:incognochat/providers/firebaseproviders/firebase_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authServiceProvider = Provider.autoDispose(
  (ref) => AuthService(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firebaseFirestoreProvider),
  ),
);

class AuthService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  AuthService({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();


  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    final user = userCredential.user!;
    return user;
  }

  User get currentUser => _firebaseAuth.currentUser!;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> setNotificationToken(final String uid, final String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == token) {
      return;
    }
    await _users.doc(uid).set({'token': token});
    prefs.setString('token', token);
  }

}
