import 'dart:developer' as developer;

class Log {
  static void i(String message) {
    developer.log('\x1B[34m$message\x1B[0m', name: 'INFO');
  }

  static void e(String message) {
    developer.log('\x1B[31m$message\x1B[0m', name: 'ERROR');
  }

  static void d(String message) {
    developer.log('\x1B[32m$message\x1B[0m', name: 'DEBUG');
  }
}
