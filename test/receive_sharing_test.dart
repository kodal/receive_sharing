import 'package:flutter_test/flutter_test.dart';
import 'package:receive_sharing/receive_sharing.dart';
import 'package:receive_sharing/receive_sharing_platform_interface.dart';
import 'package:receive_sharing/receive_sharing_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockReceiveSharingPlatform
    with MockPlatformInterfaceMixin
    implements ReceiveSharingPlatform {

  @override
  Stream<Map<String, String>> receive() => Stream.fromIterable([
        {"text": "test"},
        {"text": "text", "subject": "subject"},
      ]);
}

void main() {
  final ReceiveSharingPlatform initialPlatform =
      ReceiveSharingPlatform.instance;

  test('$MethodChannelReceiveSharing is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelReceiveSharing>());
  });

  test('receive', () async {
    final fakePlatform = MockReceiveSharingPlatform();
    ReceiveSharingPlatform.instance = fakePlatform;
    expect(
        ReceiveSharing.receive(),
        emitsInOrder([
          {"text": "test"},
          {"text": "text", "subject": "subject"},
        ]));
  });
}
