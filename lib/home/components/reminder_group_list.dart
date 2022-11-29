import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/home/components/add_group_card.dart';
import 'package:quick_reminders/home/components/reminder_group_card.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/reminders/components/add_reminder_group_modal.dart';
import 'package:quick_reminders/reminders/reminders_controller.dart';

/// Shows a list of reminder groups.
class ReminderGroupList extends ConsumerWidget {
  /// Default constructor.
  const ReminderGroupList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderGroupStream = ref.watch(
      RemindersController.reminderGroupStream,
    );

    return reminderGroupStream.when(
      data: (data) {
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: ReminderGroupCard.cardHeight,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: data.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 80 / 100,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return AddGroupCard(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => const AddReminderGroupModal(),
                    ),
                  );
                }

                return ReminderGroupCard(
                  title: data.elementAt(index - 1).title,
                  numReminders: data.elementAt(index - 1).activeReminders,
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
        myLog.e(
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
    );
  }
}
