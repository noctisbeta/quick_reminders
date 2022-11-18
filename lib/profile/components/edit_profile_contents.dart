import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/common/rounded_button.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/profile/components/edit_tile.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/models/profile.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// Contents of the edit profile view.
class EditProfileContents extends StatelessWidget {
  /// Default controller.
  const EditProfileContents({
    required this.profileController,
    required this.profileStream,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  /// The profile controller.
  final ProfileController profileController;

  /// Profile stream.
  final AsyncValue<Profile> profileStream;

  /// Edit callback.
  final void Function() onConfirm;

  /// Cancel callback.
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...<Widget>[
          EditTile(
            leading: const Icon(
              Icons.edit,
              color: kTertiaryColor,
            ),
            title: profileStream.when(
              data: (profile) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: profile.firstName,
                    hintStyle: const TextStyle(
                      color: kSecondaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: kSecondaryColor,
                  ),
                );
              },
              error: (error, stackTrace) {
                return const Text(
                  'Error',
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                );
              },
              loading: () {
                return const Text(
                  'Loading',
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                );
              },
            ),
          ),
        ]
            .eachFollowedBy(
              const Divider(
                color: kSecondaryColor,
              ),
            )
            .toList(),
        const SizedBox(
          height: 36,
        ),
        RoundedButton(
          onPressed: onCancel,
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        RoundedButton(
          fillColor: Colors.white,
          onPressed: () {},
          child: const Text(
            'CONFIRM',
            style: TextStyle(
              color: kQuinaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
