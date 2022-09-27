import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/widgets/edit_profile_contents.dart';
import 'package:quick_reminders/profile/widgets/profile_card.dart';
import 'package:quick_reminders/profile/widgets/profile_contents.dart';

/// Profile view.
class ProfileView extends HookConsumerWidget {
  /// Default constructor.
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(
      ProfileController.profileStreamProvider,
    );

    final profileController = ref.read(
      ProfileController.provider,
    );

    final pageController = usePageController();

    return Scaffold(
      body: BackgroundStack(
        background: const AnimatedBackground(
          stops: [
            0.25,
            0.25,
          ],
          initialColors: [
            kQuaternaryColor,
            kQuaternaryColor,
          ],
          finalColors: [
            kTertiaryColor,
            kQuaternaryColor,
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kQuaternaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ProfileCard(
                    profileStream: profileStream,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ExpandablePageView(
                    controller: pageController,
                    children: [
                      ProfileContents(
                        profileController: profileController,
                        onEditTapped: () {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      EditProfileContents(
                        profileController: profileController,
                        profileStream: profileStream,
                        onConfirm: () {},
                        onCancel: () {
                          pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
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
