import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/components/add_friend_dialog.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/routing/routes.dart';

/// Friends view.
class FriendsView extends ConsumerWidget {
  /// Default constructor.
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendStream = ref.watch(ProfileController.friendStream);

    return WillPopScope(
      onWillPop: () async {
        context.goNamed(Routes.profile.name);
        return false;
      },
      child: Scaffold(
        backgroundColor: kQuaternaryColor,
        appBar: AppBar(
          title: const Text('Friends'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddFriendDialog(),
          ),
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: friendStream.when(
            data: (data) {
              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white,
                ),
                itemBuilder: (context, index) {
                  final friend = data.elementAt(index);
                  return ListTile(
                    title: Text(
                      '${friend.firstName} ${friend.lastName}',
                      style: const TextStyle(
                        color: kTertiaryColor,
                      ),
                    ),
                    subtitle: Text(
                      friend.email,
                      style: const TextStyle(
                        color: kQuinaryColor,
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              myLog.e('Error in friend stream', error, stackTrace);
              return const Text('Error');
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
