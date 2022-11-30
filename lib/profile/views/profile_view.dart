import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/common/animated_background.dart';
import 'package:quick_reminders/common/background_stack.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/profile/components/profile_card.dart';
import 'package:quick_reminders/profile/components/tile_button.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/routing/routes.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// Profile view.
class ProfileView extends HookConsumerWidget {
  /// Default constructor.
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(ProfileController.profileStreamProvider);

    final profileController = ref.read(ProfileController.provider);

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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TileButton(
                        onTap: () => context.goNamed(Routes.friends.name),
                        leading: const Icon(
                          Icons.tag_faces,
                          color: kTertiaryColor,
                        ),
                        title: const Text(
                          'Friends',
                          style: TextStyle(
                            fontSize: 17,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                      TileButton(
                        onTap: () {},
                        leading: const Icon(
                          Icons.edit,
                          color: kTertiaryColor,
                        ),
                        title: const Text(
                          'Edit profile',
                          style: TextStyle(
                            fontSize: 17,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                      TileButton(
                        onTap: () {
                          context.goNamed(Routes.authentication.name);
                          profileController.signOut();
                        },
                        leading: const Icon(
                          Icons.logout,
                          color: kTertiaryColor,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 17,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                      TileButton(
                        onTap: () {},
                        leading: const Icon(
                          Icons.delete,
                          color: kTertiaryColor,
                        ),
                        title: const Text(
                          'Delete account',
                          style: TextStyle(
                            fontSize: 17,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    ]
                        .eachFollowedBy(
                          const Divider(
                            color: kSecondaryColor,
                          ),
                        )
                        .toList(),
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
