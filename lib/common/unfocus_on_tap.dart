import 'package:flutter/cupertino.dart';

/// A widget that unfocuses the keyboard when tapped.
class UnfocusOnTap extends StatelessWidget {
  /// Default constructor.
  const UnfocusOnTap({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
