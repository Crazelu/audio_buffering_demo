import 'dart:developer' as dev;

class Logger {
  final Type type;

  Logger(this.type);

  void log(Object? message) {
    dev.log("$type: $message");
  }
}
