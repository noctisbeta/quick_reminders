import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/registration_controller.dart';
import 'package:quick_reminders/authentication/views/authentication_view.dart';
import 'package:quick_reminders/authentication/views/email_verified_view.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/authentication/widgets/rotation_hero.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/hooks/countdown_hook.dart';
import 'package:quick_reminders/hooks/periodic_hook.dart';
import 'package:quick_reminders/utilities/routing_functions.dart';

/// Email verification view.
class EmailVerificationView extends HookConsumerWidget {
  /// Default constructor.
  const EmailVerificationView({
    this.fromLogin = false,
    super.key,
  });

  /// Whether this view was pushed from the init widget.
  final bool fromLogin;

  /// Checks if the current user's email is verified and takes appropriate action.
  void emailCheck(WidgetRef ref, BuildContext context) {
    ref
        .read(
          RegistrationController.provider.notifier,
        )
        .isEmailVerified()
        .then((value) {
      if (value) {
        pushReplacement(
          context,
          const EmailVerifiedView(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationController = ref.watch(
      RegistrationController.provider.notifier,
    );

    final registrationState = ref.watch(
      RegistrationController.provider,
    );

    usePeriodic(
      const Duration(seconds: 3),
      () => emailCheck(ref, context),
    );

    final resent = useState(false);
    final firstResend = useState(true);

    useEffect(
      () {
        if (firstResend.value) {
          resent.value = true;
        }
        return;
      },
      const [],
    );

    final seconds = useCountdown(
      duration: const Duration(seconds: 60),
      callback: () {
        firstResend.value = false;
      },
      active: resent,
    );

    return Scaffold(
      body: BackgroundStack(
        background: AnimatedBackground(
          initialColors: [
            Colors.blue[100]!,
            Colors.blue[300]!,
            Colors.blue[400]!,
          ],
          finalColors: [
            Colors.blue[400]!,
            Colors.blue[800]!,
            Colors.blue[900]!,
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16,
                ),
                const RotationHero(
                  tag: 'logo',
                  child: Icon(
                    Icons.email,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Text(
                  'Email verification',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Please check your email and click on the link to verify your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Hero(
                  tag: 'signUpButton',
                  child: RoundedButton(
                    isLoading: registrationState.isLoading,
                    isDisabled: resent.value,
                    onPressed: () {
                      registrationController.resendEmailVerification().then(
                        (value) {
                          if (value) {
                            resent.value = true;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something went wrong. Please try again later.'),
                              ),
                            );
                          }
                        },
                      );
                    },
                    fillColor: !resent.value ? Colors.white : null,
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: resent.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      firstChild: Text(
                        'RESEND EMAIL',
                        style: TextStyle(
                          color: Colors.blue[500],
                        ),
                      ),
                      secondChild: Text(
                        firstResend.value ? 'RESEND IN $seconds' : '$seconds',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RoundedButton(
                  onPressed: () {
                    if (fromLogin) {
                      pushReplacement(
                        context,
                        const AuthenticationView(),
                      );
                    } else {
                      pop(context);
                    }
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
