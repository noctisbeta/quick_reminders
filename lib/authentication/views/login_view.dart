import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/authentication/models/login/login_data.dart';
import 'package:quick_reminders/authentication/views/email_verification_view.dart';
import 'package:quick_reminders/authentication/views/reset_password_view.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/authentication/widgets/or_divider.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/common/unfocus_on_tap.dart';
import 'package:quick_reminders/home/home_view.dart';
import 'package:quick_reminders/utilities/routing_functions.dart';

/// Login view.
class LoginView extends HookConsumerWidget {
  /// Default constructor.
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginData = useState(
      LoginData.empty(),
    ).value;

    final loginController = ref.watch(
      LoginController.provider.notifier,
    );

    final loginState = ref.watch(
      LoginController.provider,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
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
                      children: [
                        MyTextField(
                          label: 'Email',
                          errorMessage: loginState.loginDataErrors.email,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            loginData.email = value;
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
                          errorMessage: loginState.loginDataErrors.password,
                          textInputAction: TextInputAction.go,
                          onChanged: (value) {
                            loginData.password = value;
                          },
                          obscured: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft.add(
                      const Alignment(0.2, 0),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        push(
                          context,
                          const ResetPasswordView(),
                        );
                      },
                      child: const Text(
                        'Forgot password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
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
                      isLoading: loginState.isLoading,
                      onPressed: () => loginController.login(loginData).then((value) {
                        if (value) {
                          if (loginController.isEmailVerifiedSync()) {
                            popAllAndPush(
                              context,
                              const HomeView(),
                            );
                          } else {
                            pushReplacement(
                              context,
                              const EmailVerificationView(
                                fromLogin: true,
                              ),
                            );
                          }
                        }
                      }),
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
                  const OrDivider(),
                  const SizedBox(
                    height: 16,
                  ),
                  if (loginState.googleInProgress)
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  else
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        loginController.signInWithGoogle().then(
                          (value) {
                            if (value) {
                              popAllAndPush(
                                context,
                                const HomeView(),
                              );
                            }
                          },
                        );
                      },
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
