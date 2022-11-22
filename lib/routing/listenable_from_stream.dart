import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

/// Creates a [Listenable] from a stream.
class ListenableFromStream extends ChangeNotifier {
  /// Default constructor.
  ListenableFromStream(
    Stream stream,
  ) {
    _subscription = stream.asBroadcastStream().listen((value) {
      Logger().d('ListenableFromStream: notifyListeners() with value: $value');

      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
