import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/home/components/add_group_card.dart';
import 'package:quick_reminders/home/components/people_group_card.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/reminders/components/add_people_group_modal.dart';
import 'package:quick_reminders/reminders/controllers/reminders_controller.dart';

/// List of people groups.
class PeopleGroupList extends ConsumerWidget {
  /// Default constructor.
  const PeopleGroupList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peopleGroupStream = ref.watch(
      RemindersController.peopleGroupStream,
    );

    return peopleGroupStream.when(
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
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => const AddPeopleGroupModal(),
                    ),
                  );
                }

                return PeopleGroupCard(
                  group: data.elementAt(index - 1),
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
    );
  }
}
