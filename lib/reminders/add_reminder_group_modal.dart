import 'package:flutter/material.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// Add reminder group modal.
class AddReminderGroupModal extends StatelessWidget {
  /// Default constructor.
  const AddReminderGroupModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 0.95,
          maxChildSize: 0.95,
          minChildSize: 0.95,
          builder: (context, controller) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: kQuaternaryColor,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
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
                          Icons.accessibility_new,
                          Icons.accessible,
                          Icons.accessible_forward,
                          Icons.account_balance,
                          Icons.account_balance_wallet,
                          Icons.account_box,
                          Icons.account_circle,
                          Icons.adb,
                          Icons.add,
                        ].mapToList(
                          (i) => DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Icon(
                              i,
                              color: Colors.white,
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
  }
}
