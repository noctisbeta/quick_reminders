import 'package:flutter/material.dart';
import 'package:quick_reminders/common/my_text_field.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Add friend dialog.
class AddFriendDialog extends StatelessWidget {
  /// Default constructor.
  const AddFriendDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kQuaternaryColor,
      title: const Text('Add friend', style: TextStyle(color: kTertiaryColor)),
      content: const SizedBox(
        height: 40,
        child: MyTextField(
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          label: 'Email',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
          ),
          child: const Text('Send request'),
        ),
      ],
    );
  }
}
