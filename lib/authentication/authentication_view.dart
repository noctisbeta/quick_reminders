import 'package:flutter/material.dart';
import 'package:quick_reminders/authentication/login_view.dart';
import 'package:quick_reminders/authentication/sign_up_view.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/routing_functions.dart';

/// View for user authentication.
class AuthenticationView extends StatefulWidget {
  /// Default constructor.
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[400]!,
                Colors.blue[800]!,
                Colors.blue[900]!,
              ],
            ),
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
                      onPressed: () => push(
                        context,
                        const SignUpView(),
                      ),
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
                      onPressed: () => push(
                        context,
                        const LoginView(),
                      ),
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
      ),
    );
  }
}
