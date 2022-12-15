import 'dart:io';

class CheckConnection {
  static Future<bool> check() async {
    var isOnline = false;

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }

    return Future.value(isOnline);
  }
}
