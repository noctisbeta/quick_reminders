import 'package:flutter/cupertino.dart';

/// Stacks [child] above [background].
class BackgroundStack extends StatelessWidget {
  /// Default constructor.
  const BackgroundStack({
    required this.background,
    required this.child,
    super.key,
  });

  /// The background widget.
  final Widget background;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        child,
      ],
    );
  }
}
