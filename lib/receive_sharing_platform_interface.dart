import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'receive_sharing_method_channel.dart';

abstract class ReceiveSharingPlatform extends PlatformInterface {
  /// Constructs a ReceiveSharingPlatform.
  ReceiveSharingPlatform() : super(token: _token);

  static final Object _token = Object();

  static ReceiveSharingPlatform _instance = MethodChannelReceiveSharing();

  /// The default instance of [ReceiveSharingPlatform] to use.
  ///
  /// Defaults to [MethodChannelReceiveSharing].
  static ReceiveSharingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ReceiveSharingPlatform] when
  /// they register themselves.
  static set instance(ReceiveSharingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<Map<String, String?>> receive() {
    throw UnimplementedError('receive() has not been implemented.');
  }
}
