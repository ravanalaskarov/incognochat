import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/providers/firebaseproviders/firebase_providers.dart';
import 'package:incognochat/services/firebase/auth_service.dart';



final authStateChangeProvider = StreamProvider.autoDispose((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final authControllerProvider = NotifierProvider.autoDispose<AuthController, bool>(() => AuthController());

class AuthController extends AutoDisposeNotifier<bool> {
  
  @override
  bool build() => false;

  User get currentUser => ref.watch(authServiceProvider).currentUser;

  Stream<User?> get authStateChange =>
      ref.watch(authServiceProvider).authStateChange;

  Future<void> signInAnonymously(BuildContext context) async {
    state = true;
    await ref.read(authServiceProvider).signInAnonymously();
    state = false;
  }

  Future<void> signOut() async {
    await ref.read(firebaseMessagingProvider).setAutoInitEnabled(false);
    await ref.read(firebaseMessagingProvider).deleteToken();
    await ref.read(firebaseFirestoreProvider).terminate();
    await ref.read(firebaseFirestoreProvider).clearPersistence();
    await ref.read(authServiceProvider).signOut();
  }


  Future<void> setNotificationToken(final String uid, final String token) async {
    await ref.read(authServiceProvider).setNotificationToken(uid, token);
  }
}