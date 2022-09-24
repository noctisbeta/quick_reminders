import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quick_reminders/authentication/views/login_view.dart';
import 'package:quick_reminders/authentication/views/sign_up_view.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/utilities/routing_functions.dart';

/// View for user authentication.
class AuthenticationView extends HookWidget {
  /// Default constructor.
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    return Scaffold(
      body: BackgroundStack(
        background: AnimatedBackground(
          controller: animationController,
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
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Spacer(),
                const Hero(
                  tag: 'logo',
                  child: Icon(
                    Icons.label,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const Spacer(
                  flex: 4,
                ),
                Hero(
                  tag: 'signUpButton',
                  child: RoundedButton(
                    onPressed: () {
                      push(
                        context,
                        const SignUpView(),
                      ).then((value) {
                        log('then');
                        animationController
                          ..value = 1
                          ..reverse();
                      });
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Hero(
                  tag: 'loginButton',
                  child: RoundedButton(
                    onPressed: () {
                      push(
                        context,
                        const LoginView(),
                      ).then((value) {
                        animationController
                          ..value = 1
                          ..reverse();
                      });
                    },
                    fillColor: Colors.white,
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
