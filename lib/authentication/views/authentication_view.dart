import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/hooks/route_aware_hook.dart';
import 'package:quick_reminders/responsive/max_width_constraint.dart';
import 'package:quick_reminders/routing/route_controller.dart';

/// View for user authentication.
class AuthenticationView extends HookConsumerWidget {
  /// Default constructor.
  const AuthenticationView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeController = ref.watch(
      RouteController.provider,
    );

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    useRouteObserver(
      routeController.routeObserver,
      didPopNext: () {
        animationController
          ..value = 1
          ..reverse();
      },
    );

    return Scaffold(
      body: BackgroundStack(
        background: AnimatedBackground(
          controller: animationController,
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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: MaxWidthConstraint(
              child: Column(
                children: [
                  const Spacer(),
                  const Hero(
                    tag: 'logo',
                    child: Icon(
                      Icons.label,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(
                    flex: 4,
                  ),
                  Hero(
                    tag: 'signUpButton',
                    child: RoundedButton(
                      onPressed: () {
                        context.goNamed('signUp');
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
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
                        context.goNamed('login');
                      },
                      fillColor: Colors.white,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
