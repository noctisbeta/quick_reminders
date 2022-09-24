import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Text field.
class MyTextField extends HookWidget {
  /// Default constructor.
  const MyTextField({
    required this.label,
    required this.onChanged,
    this.obscured,
    this.prefixIcon,
    super.key,
  });

  /// The label of the text field.
  final String label;

  /// The callback that is called when the text changes.
  final void Function(String)? onChanged;

  /// If true, the text will be obscured.
  final bool? obscured;

  /// Prefix icon.
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final isFocused = useState(false);
    useEffect(
      () {
        focusNode.addListener(() {
          isFocused.value = focusNode.hasFocus;
        });
        return;
      },
      [focusNode],
    );
    final obscuredText = useState(obscured ?? false);

    return TextField(
      onChanged: onChanged,
      onTap: focusNode.requestFocus,
      focusNode: focusNode,
      obscureText: obscuredText.value,
      cursorWidth: 1.2,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: obscured != null && isFocused.value
            ? IconButton(
                onPressed: () {
                  obscuredText.value = !obscuredText.value;
                },
                icon: Icon(
                  obscuredText.value ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              )
            : null,
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.all(16),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
