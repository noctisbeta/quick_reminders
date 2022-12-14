import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional/functional.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/components/google_button.dart';
import 'package:quick_reminders/authentication/components/or_divider.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/authentication/models/login/login_data.dart';
import 'package:quick_reminders/common/animated_background.dart';
import 'package:quick_reminders/common/background_stack.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/common/unfocus_on_tap.dart';
import 'package:quick_reminders/responsive/max_width_constraint.dart';
import 'package:quick_reminders/routing/routes.dart';

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
            child: MaxWidthConstraint(
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
                          Hero(
                            tag: 'email',
                            child: Material(
                              type: MaterialType.transparency,
                              child: MyTextField(
                                label: 'Email',
                                textInputType: TextInputType.emailAddress,
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
                          context.goNamed('sendResetPassword');
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
                        onPressed: () => loginController.login(loginData).then(
                              (value) => value.match(
                                ifFalse: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login failed'),
                                  ),
                                ),
                                ifTrue: () => loginController
                                    .isEmailVerified()
                                    .match(
                                      ifFalse: () =>
                                          context.goNamed(Routes.verify.name),
                                      ifTrue: () =>
                                          context.goNamed(Routes.home.name),
                                    ),
                              ),
                            ),
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
                    loginState.googleInProgress.match(
                      ifFalse: () => GoogleButton(
                        onPressed: () => loginController
                            .signInWithGoogle()
                            .then(
                              (either) => either.match(
                                (exception) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login failed'),
                                  ),
                                ),
                                (_) => context.goNamed(Routes.home.name),
                              ),
                            ),
                      ),
                      ifTrue: () => const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
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
