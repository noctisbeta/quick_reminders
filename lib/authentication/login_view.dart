import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/authentication_view_controller.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';

/// Login view.
class LoginView extends StatefulHookConsumerWidget {
  /// Default constructor.
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  void initState() {
    super.initState();

    ref.read(AuthenticationViewController.provider.notifier).startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final ac = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    if (!ac.isAnimating && !ac.isCompleted) {
      ac.forward();
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // viewController.colorTween(Colors.blue[400]!, Colors.blue[100]!),
                  // viewController.colorTween(Colors.blue[800]!, Colors.blue[300]!),
                  // viewController.colorTween(Colors.blue[900]!, Colors.blue[400]!),
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
                ].map((e) => e.animate(ac).value!).toList(),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Hero(
                        tag: 'logo',
                        child: Icon(
                          Icons.app_registration,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      MyTextField(
                        label: 'Email',
                        onChanged: (value) {},
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MyTextField(
                        label: 'Password',
                        onChanged: (value) {},
                        obscured: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.blue[600],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.apple,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Hero(
                        tag: 'loginButton',
                        child: RoundedButton(
                          onPressed: () {},
                          fillColor: Colors.white,
                          child: Text(
                            'LOGIN',
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
        ),
      ),
    );
  }
}
