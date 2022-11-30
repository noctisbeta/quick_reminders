import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/components/people_group_card.dart';
import 'package:quick_reminders/reminders/controllers/reminders_controller.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';

/// Share reminder group modal.
class ShareReminderGroupModal extends ConsumerWidget {
  /// Default constructor.
  const ShareReminderGroupModal({
    required this.reminderGroup,
    super.key,
  });

  /// Reminder group.
  final SurfaceReminderGroup reminderGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderCtl = ref.watch(RemindersController.provider);

    final peopleGroupStream = ref.watch(RemindersController.peopleGroupStream);

    void handleShareReminderGroup(List<String> userIds) => reminderCtl
        .shareReminderGroupWith(userIds, reminderGroup.id)
        .then(
          (either) => either.peekLeft(
            (exception) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to share reminder group.'),
              ),
            ),
          ),
        )
        .then((_) => Navigator.of(context).pop());

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 0.95,
          maxChildSize: 0.95,
          minChildSize: 0.95,
          builder: (context, controller) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: kQuaternaryColor,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                controller: controller,
                child: Column(
                  children: [
                    const Text(
                      'Share Reminder Group',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    peopleGroupStream.when(
                      data: (peopleGroups) => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: peopleGroups.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final peopleGroup = peopleGroups[index];

                          return GestureDetector(
                            onTap: () =>
                                handleShareReminderGroup(peopleGroup.userIds),
                            child: AbsorbPointer(
                              child: PeopleGroupCard(
                                group: peopleGroup,
                              ),
                            ),
                          );
                        },
                      ),
                      error: (err, trace) => const Text('Error'),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
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
  }
}
