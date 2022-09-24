import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/views/authentication_view.dart';

import 'package:quick_reminders/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: InitWidget(),
      ),
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
