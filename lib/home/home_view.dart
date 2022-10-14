import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/widgets/add_group_card.dart';
import 'package:quick_reminders/home/widgets/people_group_card.dart';
import 'package:quick_reminders/home/widgets/reminder_group_card.dart';
import 'package:quick_reminders/home/widgets/section_header.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/widgets/profile_avatar.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          log('Add reminder');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      log(
                        'Error in profile stream: $error \n stackTrace: $stackTrace',
                        stackTrace: stackTrace,
                      );

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
              const SizedBox(
                height: 8,
              ),
              const SectionHeader(
                title: 'People Groups',
              ),
              const SizedBox(
                height: 8,
              ),
              // TODO(Janez): Horizontal scrollable list of groups, on edit pushes a new screen
              // with a vertical list, every group card has a hero tag.
              const Align(
                alignment: Alignment.centerLeft,
                child: AddGroupCard(),
              ),
              const SizedBox(
                height: 16,
              ),
              const SectionHeader(
                title: 'Reminder groups',
              ),
              const SizedBox(
                height: 8,
              ),
              // TODO (Janez): Grid view with carousel pages.
              const Align(
                alignment: Alignment.centerLeft,
                child: ReminderGroupCard(
                  title: 'Grocery List',
                  numReminders: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
