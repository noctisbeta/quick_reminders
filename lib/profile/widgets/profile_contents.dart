import 'package:flutter/material.dart';
import 'package:quick_reminders/authentication/views/authentication_view.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/widgets/tile_button.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';
import 'package:quick_reminders/utilities/routing_functions.dart';

/// Contents of the profile view.
class ProfileContents extends StatelessWidget {
  /// Default controller.
  const ProfileContents({
    required this.profileController,
    required this.onEditTapped,
    super.key,
  });

  /// The profile controller.
  final ProfileController profileController;

  /// Edit callback.
  final void Function() onEditTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TileButton(
          onTap: onEditTapped,
          leading: const Icon(
            Icons.edit,
            color: kTertiaryColor,
          ),
          title: const Text(
            'Edit profile',
            style: TextStyle(
              fontSize: 17,
              color: kSecondaryColor,
            ),
          ),
        ),
        TileButton(
          onTap: () {
            popAllAndPush(
              context,
              const AuthenticationView(),
            );
            profileController.signOut();
          },
          leading: const Icon(
            Icons.logout,
            color: kTertiaryColor,
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 17,
              color: kSecondaryColor,
            ),
          ),
        ),
        TileButton(
          onTap: () {},
          leading: const Icon(
            Icons.delete,
            color: kTertiaryColor,
          ),
          title: const Text(
            'Delete account',
            style: TextStyle(
              fontSize: 17,
              color: kSecondaryColor,
            ),
          ),
        ),
      ]
          .eachFollowedBy(
            const Divider(
              color: kSecondaryColor,
            ),
          )
          .toList(),
    );
  }
}
