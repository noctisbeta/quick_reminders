import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Profile avata.
class ProfileAvatar extends HookWidget {
  /// Default constructor.
  const ProfileAvatar({
    required this.child,
    this.expanded = false,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// The size of the avatar.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profileAvatar',
      child: AbsorbPointer(
        absorbing: expanded,
        child: GestureDetector(
          onTap: () {
            context.goNamed('profile');
          },
          child: CircleAvatar(
            backgroundColor: kQuinaryColor,
            radius: expanded ? 40 : 20,
            child: child,
          ),
        ),
      ),
    );
  }
}
