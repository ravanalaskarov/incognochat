
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreProvider = Provider.autoDispose((ref) => FirebaseFirestore.instance);
final firebaseAuthProvider = Provider.autoDispose((ref) => FirebaseAuth.instance);
final firebaseMessagingProvider = Provider.autoDispose((ref) => FirebaseMessaging.instance);