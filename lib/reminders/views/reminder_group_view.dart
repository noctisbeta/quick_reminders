import 'package:flutter/material.dart';

/// A widget that displays a reminder group.
class ReminderGroupView extends StatelessWidget {
  /// Default constructor.
  const ReminderGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Group'),
      ),
      body: const Center(
        child: Text('Reminder Group'),
      ),
    );
  }
}
