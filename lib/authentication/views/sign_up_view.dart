import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/authentication_controller.dart';
import 'package:quick_reminders/authentication/models/registration_data.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/common/unfocus_on_tap.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// VRegistration view.
class SignUpView extends HookConsumerWidget {
  /// Default constructor.
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationData = useState(
      RegistrationData.empty(),
    ).value;

    final authenticationState = ref.watch(
      AuthenticationController.provider,
    );

    final authenticationController = ref.watch(
      AuthenticationController.provider.notifier,
    );

    return UnfocusOnTap(
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
                    FocusScope(
                      child: Column(
                        children: <Widget>[
                          MyTextField(
                            label: 'First Name',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
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
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.next,
                            errorMessage: authenticationState.registrationDataErrors.email,
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
                            textInputAction: TextInputAction.go,
                            errorMessage: authenticationState.registrationDataErrors.password,
                            onChanged: (value) {
                              registrationData.password = value;
                            },
                            obscured: true,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                        ].separatedByToList(
                          const SizedBox(
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Hero(
                      tag: 'signUpButton',
                      child: RoundedButton(
                        isLoading: authenticationState.processingState.isLoading,
                        onPressed: () {
                          authenticationController.completeRegistration(
                            registrationData,
                          );
                        },
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
    );
  }
}
