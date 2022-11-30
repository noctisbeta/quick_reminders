import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';
import 'package:quick_reminders/reminders/reminders_controller.dart';

/// A widget that displays a reminder group.
class ReminderGroupView extends ConsumerWidget {
  /// Default constructor.
  const ReminderGroupView({
    required this.group,
    super.key,
  });

  /// Surface reminder group.
  final SurfaceReminderGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminersStream =
        ref.watch(RemindersController.reminderGroupContentStream(group));

    return Scaffold(
      backgroundColor: kQuaternaryColor,
      appBar: AppBar(
        title: Text(group.title),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: reminersStream.when(
        data: (content) => ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            final reminder = content[index];
            return ListTile(
              title: Text(reminder.title),
              subtitle: Text(reminder.description),
            );
          },
        ),
        error: (err, trace) => Text(err.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
