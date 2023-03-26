// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:developer';
import 'dart:html' as html show window;
import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'receive_sharing_platform_interface.dart';

/// A web implementation of the ReceiveSharingPlatform of the ReceiveSharing plugin.
class ReceiveSharingWeb extends ReceiveSharingPlatform {
  final StreamController<Map<String, String>> controller = StreamController();

  /// Constructs a ReceiveSharingWeb
  ReceiveSharingWeb() {
    log('plugin start');
    final uri = Uri.base;
    log(uri.toString());
    final text = uri.queryParameters["text"] ?? uri.queryParameters["url"];
    if (text == null || text.isEmpty) return;
    final subject =
        uri.queryParameters["subject"] ?? uri.queryParameters["title"];
    controller.sink.add({
      "text": text,
      if (subject != null && subject.isNotEmpty) "subject": subject,
    });
  }

  static void registerWith(Registrar registrar) {
    ReceiveSharingPlatform.instance = ReceiveSharingWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Stream<Map<String, String>> receive() {
    return controller.stream;
  }
}
