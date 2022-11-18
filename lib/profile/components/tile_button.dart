import 'package:flutter/material.dart';

/// Button.
class TileButton extends StatelessWidget {
  /// Default constructor.
  const TileButton({
    required this.onTap,
    required this.leading,
    required this.title,
    super.key,
  });

  /// On tap.
  final void Function() onTap;

  /// Leading widget.
  final Widget leading;

  /// Title.
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: leading,
      title: title,
    );
  }
}
