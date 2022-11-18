import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/components/animated_background.dart';
import 'package:quick_reminders/authentication/components/background_stack.dart';
import 'package:quick_reminders/authentication/components/rotation_hero.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/common/rounded_button.dart';

/// Email verifiedn view.
class EmailVerifiedView extends HookConsumerWidget {
  /// Default constructor.
  const EmailVerifiedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.read(
      LoginController.provider.notifier,
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BackgroundStack(
          background: AnimatedBackground(
            initialColors: [
              Colors.blue[400]!,
              Colors.blue[800]!,
              Colors.blue[900]!,
            ],
            finalColors: [
              Colors.blue[100]!,
              Colors.blue[300]!,
              Colors.blue[400]!,
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const RotationHero(
                    tag: 'logo',
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Text(
                    'Verification successful',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'You can now use the application ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Hero(
                    tag: 'signUpButton',
                    child: RoundedButton(
                      onPressed: () {
                        if (loginController.isUserLoggedIn()) {
                          context.goNamed('home');
                        } else {
                          context.goNamed('authentication');
                        }
                      },
                      fillColor: Colors.white,
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Colors.blue[500],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
