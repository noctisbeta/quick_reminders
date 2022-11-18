import 'package:flutter/cupertino.dart';

/// Max width constraint.
class MaxWidthConstraint extends StatelessWidget {
  /// Default.
  const MaxWidthConstraint({
    required this.child,
    super.key,
  });

  /// Child.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: child,
      ),
    );
  }
}
