import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:functional/functional.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/common/unfocus_on_tap.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/reminders/components/share_reminder_group_modal.dart';
import 'package:quick_reminders/reminders/controllers/reminders_controller.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';
import 'package:quick_reminders/routing/routes.dart';

/// A widget that displays a reminder group.
class ReminderGroupView extends HookConsumerWidget {
  /// Default constructor.
  const ReminderGroupView({
    required this.group,
    super.key,
  });

  /// Surface reminder group.
  final SurfaceReminderGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders =
        ref.watch(RemindersController.reminderGroupContentStream(group));

    final remindersCtl = ref.watch(RemindersController.provider);

    final newReminder = useState<Option<String>>(const None());
    final focusNode = useFocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        newReminder.value = const None();
      }
    });

    void handleAdd() => remindersCtl
        .createReminder(group.id, newReminder.value.unwrap())
        .then(
          (either) => either.peekLeft(
            (exception) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create reminder.')),
            ),
          ),
        )
        .then((_) => newReminder.value = const None())
        .then((_) => focusNode.requestFocus());

    void handleDelete(String reminderId) =>
        remindersCtl.deleteReminder(group.id, reminderId).then(
              (either) => either.peekLeft(
                (exception) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete reminder.'),
                  ),
                ),
              ),
            );

    return WillPopScope(
      onWillPop: () async {
        context.goNamed(Routes.home.name);
        return false;
      },
      child: UnfocusOnTap(
        child: Scaffold(
          backgroundColor: kQuaternaryColor,
          appBar: AppBar(
            title: Text(group.title),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.spatial_tracking_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) =>
                      ShareReminderGroupModal(reminderGroup: group),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            onPressed: () => newReminder.value.match(
              none: () => newReminder.value = const Some(''),
              some: (_) {},
            ),
            backgroundColor: kPrimaryColor,
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: reminders.when(
              data: (content) => ListView.separated(
                itemCount: newReminder.value.match(
                  none: () => content.length,
                  some: (_) => content.length + 1,
                ),
                separatorBuilder: (context, index) => const Divider(
                  color: kTertiaryColor,
                ),
                itemBuilder: (context, index) {
                  if (index == content.length) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode,
                            autofocus: true,
                            cursorColor: kPrimaryColor,
                            style: const TextStyle(
                              color: kTertiaryColor,
                              fontSize: 18,
                            ),
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            onChanged: (value) =>
                                newReminder.value = Some(value),
                            onSubmitted: (value) =>
                                value.isNotEmpty ? handleAdd() : null,
                          ),
                        ),
                        IconButton(
                          onPressed: handleAdd,
                          icon: Icon(
                            Icons.check,
                            color: newReminder.value.match(
                              none: () => Colors.grey,
                              some: (value) =>
                                  value.isEmpty ? Colors.grey : kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final reminder = content[index];
                  return Slidable(
                    key: ValueKey(reminder.id),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.3,
                      dismissible: DismissiblePane(
                        onDismissed: () => handleDelete(reminder.id),
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (a) => handleDelete(reminder.id),
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: 'Complete',
                          padding: EdgeInsets.zero,
                          spacing: 2,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ],
                    ),
                    child: Builder(
                      builder: (context) {
                        return ListTile(
                          title: Text(
                            reminder.title,
                            style: const TextStyle(
                              color: kTertiaryColor,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(reminder.description),
                          trailing: IconButton(
                            onPressed: () =>
                                Slidable.of(context)?.openStartActionPane(),
                            icon: const Icon(
                              Icons.check_circle_outlined,
                              color: kTertiaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              error: (err, trace) => Text(err.toString()),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
