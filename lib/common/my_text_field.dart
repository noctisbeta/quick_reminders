import 'dart:developer';

import 'package:flutter/material.dart';

/// Text field.
class MyTextField extends StatefulWidget {
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
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool? obscured = widget.obscured;
  bool isFocused = false;

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: focusNode.requestFocus,
      focusNode: focusNode,
      obscureText: obscured ?? false,
      cursorWidth: 1.2,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscured != null && isFocused
            ? IconButton(
                onPressed: () {
                  if (obscured == null) {
                    return;
                  }
                  log('lal  $obscured');
                  setState(() {
                    obscured = !obscured!;
                  });
                },
                icon: Icon(
                  obscured! ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              )
            : null,
        labelText: widget.label,
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
