import 'receive_sharing_platform_interface.dart';

class ReceiveSharing {
  static Stream<Map<String, String?>> receive() {
    return ReceiveSharingPlatform.instance.receive();
  }
}
