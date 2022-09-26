import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provides the firebase auth instance.
final authProvider = Provider.autoDispose(
  (ref) => FirebaseAuth.instance,
);

/// Provides the firebase firestore instance.
final storeProvider = Provider.autoDispose(
  (ref) => FirebaseFirestore.instance,
);
