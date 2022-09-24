import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/authentication_view_controller.dart';
import 'package:quick_reminders/authentication/registration_data.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// VRegistration view.
class SignUpView extends ConsumerStatefulWidget {
  /// Default constructor.
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final RegistrationData registrationData = RegistrationData.empty();

  @override
  void initState() {
    super.initState();

    ref.read(AuthenticationViewController.provider.notifier).startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final animationState = ref.watch(AuthenticationViewController.provider);

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
                      ...<Widget>[
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
                      ].separatedBy(
                        const SizedBox(
                          height: 16,
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
