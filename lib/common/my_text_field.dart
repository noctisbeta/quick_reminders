import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Text field.
class MyTextField extends HookWidget {
  /// Default constructor.
  const MyTextField({
    required this.label,
    required this.onChanged,
    this.errorMessage = '',
    this.obscured,
    this.prefixIcon,
    this.textCapitalization,
    this.textInputAction,
    this.initialText,
    this.textInputType,
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

  /// The error message.
  final String errorMessage;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Text capitalization.
  final TextCapitalization? textCapitalization;

  /// Text input type.
  final TextInputType? textInputType;

  /// Initial text.
  final String? initialText;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final isFocused = useState(false);
    final textEditingController = useTextEditingController(
      text: initialText,
    );

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

    return Column(
      children: [
        TextField(
          keyboardType: textInputType,
          controller: textEditingController,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
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
                      obscuredText.value
                          ? Icons.visibility_off
                          : Icons.visibility,
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
              borderSide: BorderSide(
                color: errorMessage.isEmpty ? Colors.white : Colors.red,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(
                color: errorMessage.isEmpty ? Colors.white : Colors.red,
              ),
            ),
          ),
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft.add(
                const Alignment(0.2, 0),
              ),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
