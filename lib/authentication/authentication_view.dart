import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/authentication_view_controller.dart';
import 'package:quick_reminders/authentication/login_view.dart';
import 'package:quick_reminders/authentication/sign_up_view.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/utilities/routing_functions.dart';

/// View for user authentication.
class AuthenticationView extends ConsumerStatefulWidget {
  /// Default constructor.
  const AuthenticationView({super.key});

  @override
  ConsumerState<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  @override
  void initState() {
    super.initState();

    // ref.read(AuthenticationViewController.provider.notifier).reverseAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final animationState = ref.watch(AuthenticationViewController.provider);

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorTween(
                  begin: Colors.blue[400],
                  end: Colors.blue[100],
                ),
                ColorTween(
                  begin: Colors.blue[800],
                  end: Colors.blue[300],
                ),
                ColorTween(
                  begin: Colors.blue[900],
                  end: Colors.blue[400],
                ),
              ].map((e) => e.transform(animationState)!).toList(),
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
                      onPressed: () {
                        push(
                          context,
                          const SignUpView(),
                        ).then(
                          (value) => ref.read(AuthenticationViewController.provider.notifier).reverseAnimation(),
                        );
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
                        ).then(
                          (value) => ref.read(AuthenticationViewController.provider.notifier).reverseAnimation(),
                        );
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
      ),
    );
  }
}
