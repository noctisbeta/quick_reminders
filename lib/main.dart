import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/authentication/views/authentication_view.dart';
import 'package:quick_reminders/authentication/views/email_verification_view.dart';
import 'package:quick_reminders/firebase/firebase_options.dart';
import 'package:quick_reminders/home/home_view.dart';

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
class InitWidget extends ConsumerWidget {
  /// Default constructor.
  const InitWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.read(
      LoginController.provider.notifier,
    );

    if (loginController.isUserLoggedIn()) {
      if (loginController.isEmailVerifiedSync()) {
        return const HomeView();
      } else {
        return const EmailVerificationView(
          fromLogin: true,
        );
      }
    } else {
      return const AuthenticationView();
    }
  }
}

/// Controller for app initialization.
class InitController {
  /// Default constructor.
  InitController(
    this.ref,
    this.auth,
  );

  /// Provides the controller.
  static final provider = Provider.autoDispose(
    (ref) => InitController(
      ref,
      FirebaseAuth.instance,
    ),
  );

  /// Riverpod ref.
  final Ref ref;

  /// Firebase auth instance.
  final FirebaseAuth auth;
}
