import 'package:flutter/material.dart';

/// Edit tile.
class EditTile extends StatelessWidget {
  /// Default constructor.
  const EditTile({
    required this.leading,
    required this.title,
    super.key,
  });

  /// Leading widget.
  final Widget leading;

  /// Title.
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: leading,
      title: title,
    );
  }
}
