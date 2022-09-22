import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_reminders/authentication/authentication_view.dart';

import 'package:quick_reminders/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      home: InitWidget(),
    ),
  );
}

/// This widget is used to initialize the app.
class InitWidget extends StatelessWidget {
  /// Default constructor.
  const InitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthenticationView();
  }
}
