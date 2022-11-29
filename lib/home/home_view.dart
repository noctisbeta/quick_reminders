import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/components/home_header.dart';
import 'package:quick_reminders/home/components/people_group_list.dart';
import 'package:quick_reminders/home/components/reminder_group_list.dart';
import 'package:quick_reminders/home/components/section_header.dart';

/// Home screen.
class HomeView extends ConsumerWidget {
  /// Default constructor.
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kQuaternaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              HomeHeader(),
              SizedBox(
                height: 16,
              ),
              SectionHeader(
                title: 'People Groups',
              ),
              SizedBox(
                height: 8,
              ),
              // TODO(Janez): Horizontal scrollable list of groups, on edit
              // pushes a new screen
              // with a vertical list, every group card has a hero tag.
              PeopleGroupList(),
              SizedBox(
                height: 16,
              ),
              SectionHeader(
                title: 'Reminder groups',
              ),
              SizedBox(
                height: 8,
              ),
              // TODO(Janez): Grid view with carousel pages.
              ReminderGroupList(),
              SizedBox(
                height: 16,
              ),
              // TODO(Janez): Fresh reminders or groups, nonempty
              SectionHeader(
                title: 'Focus',
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
