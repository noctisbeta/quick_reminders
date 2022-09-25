import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/profile/profile_avatar.dart';
import 'package:quick_reminders/profile/profile_controller.dart';

/// Home screen.
class HomeView extends ConsumerWidget {
  /// Default constructor.
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(
      ProfileController.profileStreamProvider,
    );

    return Scaffold(
      backgroundColor: kQuaternaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  profileStream.when(
                    data: (profile) {
                      return ProfileAvatar(
                        child: Text(
                          profile.initials,
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return const ProfileAvatar(
                        child: Text(
                          '',
                        ),
                      );
                    },
                    loading: () {
                      return const ProfileAvatar(
                        child: SizedBox(
                          height: 37,
                          width: 37,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  // notification bell
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: kSecondaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
