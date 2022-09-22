import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';

/// Login view.
class LoginView extends StatefulWidget {
  /// Default constructor.
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  double percentage = 0;

  Color colorTween(Color begin, Color end) {
    return ColorTween(
      begin: begin,
      end: end,
    ).transform(percentage)!;
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        setState(() {
          percentage += 0.05;
        });

        if (percentage >= 1) {
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  colorTween(Colors.blue[400]!, Colors.blue[100]!),
                  colorTween(Colors.blue[800]!, Colors.blue[300]!),
                  colorTween(Colors.blue[900]!, Colors.blue[400]!),
                ],
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
