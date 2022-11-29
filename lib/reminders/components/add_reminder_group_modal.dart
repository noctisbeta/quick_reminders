import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/reminders/components/modal_header.dart';
import 'package:quick_reminders/reminders/reminders_controller.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// Add reminder group modal.
class AddReminderGroupModal extends HookConsumerWidget {
  /// Default constructor.
  const AddReminderGroupModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderCtl = ref.watch(RemindersController.provider);

    final groupTitle = useState('');

    void handleSubmit() {
      reminderCtl.createReminderGroup(groupTitle.value).then(
            (either) => either.peekLeft(
              (exception) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to create group.'),
                ),
              ),
            ),
          );

      Navigator.pop(context);
    }

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
                    ModalHeader(
                      title: 'Add Reminder Group',
                      disabled: groupTitle.value.isEmpty,
                      onSubmit: handleSubmit,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyTextField(
                      label: 'Group Title',
                      prefixIcon: const Icon(
                        Icons.title,
                        color: Colors.white,
                      ),
                      onChanged: (val) => groupTitle.value = val,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GridView.count(
                      crossAxisCount: 6,
                      controller: controller,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      children: const [
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.indigo,
                        Colors.blue,
                        Colors.lightBlue,
                        Colors.cyan,
                      ].mapToList(
                        (c) => DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
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
