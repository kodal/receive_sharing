import 'receive_sharing_platform_interface.dart';

class ReceiveSharing {
  Future<String?> getPlatformVersion() {
    return ReceiveSharingPlatform.instance.getPlatformVersion();
  }

  static Stream<Map<String, String?>> receive() {
    return ReceiveSharingPlatform.instance.receive();
  }
}
