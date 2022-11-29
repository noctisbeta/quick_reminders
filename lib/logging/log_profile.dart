// ignore_for_file: public_member_api_docs

import 'package:logger/logger.dart';

final myLog = Logger(
  // printer: MyPrinter(),
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: true,
  ),
);

class MyPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    return [
      if (event.stackTrace != null && event.level == Level.error ||
          event.level == Level.wtf)
        '${event.stackTrace}',
      if (color != null) color('${DateTime.now()} $emoji ${event.message}')
    ];
  }
}
