import 'package:flutter/material.dart';

/// A button with rounded corners.
class RoundedButton extends StatelessWidget {
  /// Default constructor.
  const RoundedButton({
    required this.onPressed,
    required this.child,
    this.fillColor,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  /// If not null, the button will be filled with [fillColor].
  final Color? fillColor;

  /// The callback that is called when the button is pressed.
  final void Function() onPressed;

  /// The widget shown in the center of the button.
  final Widget child;

  /// If true, the button will show a loading state.
  final bool isLoading;

  /// If true, the button will not process any input.
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading || isDisabled,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          splashColor: fillColor == null ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: fillColor,
              border: Border.all(
                color: Colors.white,
                width: 0.8,
              ),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
