
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'receive_sharing_platform_interface.dart';

/// An implementation of [ReceiveSharingPlatform] that uses method channels.
class MethodChannelReceiveSharing extends ReceiveSharingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('receive_sharing');

  @visibleForTesting
  final eventChannel = const EventChannel("receive_sharing/events");

  @override
  Stream<Map<String, String?>> receive() {
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, String?>.from(event));
  }
}
