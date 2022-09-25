import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/widgets/animated_background.dart';
import 'package:quick_reminders/authentication/widgets/background_stack.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/profile/profile_avatar.dart';
import 'package:quick_reminders/profile/profile_controller.dart';

/// Profile view.
class ProfileView extends ConsumerWidget {
  /// Default constructor.
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(
      ProfileController.profileStreamProvider,
    );

    return Scaffold(
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
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kQuaternaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kQuaternaryColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        profileStream.when(
                          data: (profile) {
                            return ProfileAvatar(
                              expanded: true,
                              child: Text(
                                profile.initials,
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            return const ProfileAvatar(
                              expanded: true,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            );
                          },
                          loading: () {
                            return const ProfileAvatar(
                              expanded: true,
                              child: SizedBox(
                                height: 76,
                                width: 76,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        profileStream.when(
                          data: (profile) {
                            return Text(
                              '${profile.firstName} ${profile.lastName}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            return const Text(
                              '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            );
                          },
                          loading: () {
                            return const Text(
                              '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
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
