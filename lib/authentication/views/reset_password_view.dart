import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState('');

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
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Hero(
                      tag: 'email',
                      child: Material(
                        type: MaterialType.transparency,
                        child: MyTextField(
                          label: 'Email',
                          initialText: loginState.loginData.email,
                          errorMessage: loginState.loginDataErrors.email,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            email.value = value;
                          },
                          prefixIcon: const Icon(
                            Icons.email,
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
                          loginController.resetPassword(email.value).then((value) {
                            if (value) {
                              // push to new screen
                            }
                          });
                        },
                        isLoading: loginState.isLoading,
                        fillColor: Colors.white,
                        child: Text(
                          'SEND',
                          style: TextStyle(
                            color: Colors.blue[500],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RoundedButton(
                      onPressed: () {},
                      child: const Text(
                        'BACK TO LOGIN',
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
