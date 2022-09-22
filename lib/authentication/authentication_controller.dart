import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_reminders/authentication/registration_data.dart';

class AuthenticationController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(RegistrationData data) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: data.email.trim(),
        password: data.password.trim(),
      );
    } catch (e) {
      print(e);
    }
  }
}
