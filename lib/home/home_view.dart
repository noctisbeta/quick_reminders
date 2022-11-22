import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/components/add_group_card.dart';
import 'package:quick_reminders/home/components/people_group_card.dart';
import 'package:quick_reminders/home/components/reminder_group_card.dart';
import 'package:quick_reminders/home/components/section_header.dart';
import 'package:quick_reminders/profile/components/profile_avatar.dart';
import 'package:quick_reminders/reminders/add_reminder_group_modal.dart';
import 'package:quick_reminders/reminders/reminders_controller.dart';

/// Home screen.
class HomeView extends ConsumerWidget {
  /// Default constructor.
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peopleGroupStream = ref.watch(
      RemindersController.peopleGroupStream,
    );

    final reminderGroupStream = ref.watch(
      RemindersController.reminderGroupStream,
    );

    return Scaffold(
      backgroundColor: kQuaternaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const ProfileAvatar(),
                  const Spacer(),
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
                height: 16,
              ),
              const SectionHeader(
                title: 'People Groups',
              ),
              const SizedBox(
                height: 8,
              ),
              // TODO(Janez): Horizontal scrollable list of groups, on edit
              // pushes a new screen
              // with a vertical list, every group card has a hero tag.
              peopleGroupStream.when(
                data: (data) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: PeopleGroupCard.cardHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: data.length + 1,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 16,
                          );
                        },
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return AddGroupCard(
                              onTap: () {},
                            );
                          }

                          return const PeopleGroupCard(
                            title: 'asd',
                            numReminders: 123,
                          );
                        },
                      ),
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                error: (error, stackTrace) {
                  Logger().e(
                    'Error in people group stream: $error',
                    error,
                    stackTrace,
                  );
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                },
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
              // TODO(Janez): Grid view with carousel pages.
              reminderGroupStream.when(
                data: (data) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: ReminderGroupCard.cardHeight,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: data.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 80 / 100,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return AddGroupCard(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      const AddReminderGroupModal(),
                                );
                              },
                            );
                          }

                          return const ReminderGroupCard(
                            title: 'asd',
                            numReminders: 123,
                          );
                        },
                      ),
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                error: (error, stackTrace) {
                  Logger().e(
                    'Error in reminder group stream: $error',
                    error,
                    stackTrace,
                  );
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // TODO(Janez): Fresh reminders or groups, nonempty
              const SectionHeader(
                title: 'Focus',
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
