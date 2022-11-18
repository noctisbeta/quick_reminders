import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/widgets/add_group_card.dart';
import 'package:quick_reminders/home/widgets/people_group_card.dart';
import 'package:quick_reminders/home/widgets/reminder_group_card.dart';
import 'package:quick_reminders/home/widgets/section_header.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/widgets/profile_avatar.dart';
import 'package:quick_reminders/reminders/reminders_controller.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// Home screen.
class HomeView extends ConsumerWidget {
  /// Default constructor.
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(
      ProfileController.profileStreamProvider,
    );

    final peopleGroupStream = ref.watch(
      RemindersController.peopleGroupStream,
    );

    final reminderGroupStream = ref.watch(
      RemindersController.reminderGroupStream,
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
                      Logger().e(
                        'Error in profile stream: $error',
                        error,
                        stackTrace,
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
              peopleGroupStream.when(
                data: (data) {
                  log(data.toString());
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
                              onTap: () {
                                log('Add group');
                              },
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
                loading: () {
                  log('loading');
                  return const Text('loading');
                },
                error: (error, stackTrace) {
                  Logger().e(
                    'Error in people group stream: $error',
                    error,
                    stackTrace,
                  );
                  return Text(error.toString());
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
                  log(data.toString());
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
                                  builder: (context) {
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: DraggableScrollableSheet(
                                          initialChildSize: 0.9,
                                          maxChildSize: 0.9,
                                          minChildSize: 0.9,
                                          builder: (context, controller) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: kQuaternaryColor,
                                              ),
                                              child: SingleChildScrollView(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                controller: controller,
                                                child: Column(
                                                  children: [
                                                    MyTextField(
                                                      label: 'Group Title',
                                                      prefixIcon: const Icon(
                                                        Icons.title,
                                                        color: Colors.white,
                                                      ),
                                                      onChanged: (value) {},
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    SizedBox(
                                                      height: 100,
                                                      child: GridView.count(
                                                        crossAxisCount: 6,
                                                        controller: controller,
                                                        crossAxisSpacing: 16,
                                                        mainAxisSpacing: 16,
                                                        children: const [
                                                          Colors.white,
                                                          Colors.red,
                                                          Colors.green,
                                                          Colors.blue,
                                                          Colors.yellow,
                                                          Colors.purple,
                                                          Colors.orange,
                                                          Colors.pink,
                                                          Colors.brown,
                                                          Colors.grey,
                                                          Colors.teal,
                                                          Colors.cyan,
                                                        ].mapToList(
                                                          (c) => DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: c,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    SizedBox(
                                                      height: 100,
                                                      child: GridView.count(
                                                        crossAxisCount: 6,
                                                        controller: controller,
                                                        crossAxisSpacing: 16,
                                                        mainAxisSpacing: 16,
                                                        children: const [
                                                          Icons.abc,
                                                          Icons.access_alarm,
                                                          Icons.accessibility,
                                                          Icons
                                                              .accessibility_new,
                                                          Icons.accessible,
                                                          Icons
                                                              .accessible_forward,
                                                          Icons.account_balance,
                                                          Icons
                                                              .account_balance_wallet,
                                                          Icons.account_box,
                                                          Icons.account_circle,
                                                          Icons.adb,
                                                          Icons.add,
                                                        ].mapToList(
                                                          (i) => DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              i,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
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
                loading: () {
                  log('loading');
                  return const Text('loading');
                },
                error: (error, stackTrace) {
                  log(error.toString());
                  return Text(error.toString());
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
