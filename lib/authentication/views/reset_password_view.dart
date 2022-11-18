import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/authentication/widgets/background_gradient.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/common/unfocus_on_tap.dart';

/// Reset password view.
class ResetPasswordView extends HookConsumerWidget {
  /// Default constructor.
  const ResetPasswordView({
    required this.oobCode,
    super.key,
  });

  /// OOB code.
  final String oobCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final confirmPassword = useState('');

    final loginController = ref.watch(
      LoginController.provider.notifier,
    );

    final loginState = ref.watch(
      LoginController.provider,
    );

    return UnfocusOnTap(
      child: Scaffold(
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
                      height: 16,
                    ),
                    const Icon(
                      Icons.label,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Please enter a new password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyTextField(
                      label: 'New password',
                      obscured: true,
                      textInputType: TextInputType.emailAddress,
                      initialText: loginState.loginData.email,
                      errorMessage: loginState.loginDataErrors.email,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        password.value = value;
                      },
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyTextField(
                      label: 'Confirm password',
                      obscured: true,
                      textInputType: TextInputType.emailAddress,
                      initialText: loginState.loginData.email,
                      errorMessage: loginState.loginDataErrors.email,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        confirmPassword.value = value;
                      },
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RoundedButton(
                      onPressed: () {
                        loginController
                            .resetPassword(password.value, oobCode)
                            .then((value) {
                          if (value) {
                            context.goNamed('resetPasswordSuccessful');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something went wrong.'),
                              ),
                            );
                          }
                        });
                      },
                      isLoading: loginState.isLoading,
                      fillColor: Colors.white,
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          color: Colors.blue[500],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RoundedButton(
                      onPressed: () {
                        context.goNamed('authentication');
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.white,
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
