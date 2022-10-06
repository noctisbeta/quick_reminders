import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_reminders/authentication/widgets/background_gradient.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/common/rounded_button.dart';

/// Reset password mail sent.
class SendResetPasswordSuccessfulView extends StatelessWidget {
  /// Default constructor.
  const SendResetPasswordSuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundStack(
        background: BackgroundGradient(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[100]!,
              Colors.blue[300]!,
              Colors.blue[400]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  const Hero(
                    tag: 'logo',
                    child: Icon(
                      Icons.label,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Success',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'A password reset email has been sent to your email address.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Hero(
                    tag: 'backToLogin',
                    child: RoundedButton(
                      onPressed: () {
                        context.goNamed('login');
                      },
                      child: const Text(
                        'BACK TO LOGIN',
                        style: TextStyle(
                          color: Colors.white,
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
