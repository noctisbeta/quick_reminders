import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:more_hooks/more_hooks.dart';
import 'package:quick_reminders/common/animated_background.dart';
import 'package:quick_reminders/common/background_stack.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/responsive/max_width_constraint.dart';
import 'package:quick_reminders/routing/route_controller.dart';
import 'package:quick_reminders/routing/routes.dart';

/// The first view that the user sees. Shows login and sign up buttons that lead
/// to the respective views.
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
      didPopNext: () => animationController
        ..value = 1
        ..reverse(),
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
                      onPressed: () => context.goNamed(Routes.signUp.name),
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
                      onPressed: () => context.goNamed(Routes.login.name),
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
