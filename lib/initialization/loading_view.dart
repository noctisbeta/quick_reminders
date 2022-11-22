import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Loading view.
class LoadingView extends StatelessWidget {
  /// Default constructor.
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: kQuaternaryColor,
          ),
        ),
      ),
    );
  }
}
