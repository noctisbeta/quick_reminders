import 'package:flutter/material.dart';

/// Error view.
class ErrorView extends StatelessWidget {
  /// Default constructor.
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
