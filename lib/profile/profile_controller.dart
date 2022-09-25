import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/profile/profile.dart';

class ProfileController {
  static final profileStreamProvider = StreamProvider(
    (ref) => _db.collection('users').doc(_auth.currentUser!.uid).snapshots().map(Profile.fromSnapshot),
  );

  // static final profileStream = _db.collection('users').doc(_auth.currentUser!.uid).snapshots().map(
  //       Profile.fromSnapshot,
  //     );

  static final _auth = FirebaseAuth.instance;

  static final _db = FirebaseFirestore.instance;
}
