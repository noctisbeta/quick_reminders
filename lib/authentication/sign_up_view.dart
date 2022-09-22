import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_reminders/authentication/registration_data.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';

/// VRegistration view.
class SignUpView extends StatefulWidget {
  /// Default constructor.
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final RegistrationData registrationData = RegistrationData.empty();

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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                        label: 'First Name',
                        onChanged: (value) {
                          registrationData.firstName = value;
                        },
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MyTextField(
                        label: 'Last Name',
                        onChanged: (value) {
                          registrationData.lastName = value;
                        },
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MyTextField(
                        label: 'Email',
                        onChanged: (value) {
                          registrationData.email = value;
                        },
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
                        onChanged: (value) {
                          registrationData.password = value;
                        },
                        obscured: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Hero(
                        tag: 'signUpButton',
                        child: RoundedButton(
                          onPressed: () {},
                          fillColor: Colors.white,
                          child: Text(
                            'SIGN UP',
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
