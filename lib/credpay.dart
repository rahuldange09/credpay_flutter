import 'dart:async';

import 'package:flutter/services.dart';

class Credpay {
  static const MethodChannel _channel = MethodChannel('credpay');

  static Future<String?> launch(String url) async {
    final String? credPayResponse =
        await _channel.invokeMethod('launchCredPay', {'url': url});
    return credPayResponse;
  }

  static Future<bool> isAppInstalled(String packageName) async {
    final bool isAppInstalled = await _channel
        .invokeMethod('isAppInstalled', {'packageName': packageName});
    return isAppInstalled;
  }
}
