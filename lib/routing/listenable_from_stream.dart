import 'dart:async';

import 'package:flutter/cupertino.dart';

/// Creates a [Listenable] from a stream.
class ListenableFromStream extends ChangeNotifier {
  /// Default constructor.
  ListenableFromStream(
    Stream stream,
  ) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
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
