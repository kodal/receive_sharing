import 'package:flutter_test/flutter_test.dart';
import 'package:receive_sharing/receive_sharing.dart';
import 'package:receive_sharing/receive_sharing_platform_interface.dart';
import 'package:receive_sharing/receive_sharing_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockReceiveSharingPlatform
    with MockPlatformInterfaceMixin
    implements ReceiveSharingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<Map<String, String>> receive() {
    // TODO: implement receive
    throw UnimplementedError();
  }
}

void main() {
  final ReceiveSharingPlatform initialPlatform = ReceiveSharingPlatform.instance;

  test('$MethodChannelReceiveSharing is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelReceiveSharing>());
  });

  test('getPlatformVersion', () async {
    ReceiveSharing receiveSharingPlugin = ReceiveSharing();
    MockReceiveSharingPlatform fakePlatform = MockReceiveSharingPlatform();
    ReceiveSharingPlatform.instance = fakePlatform;

    expect(await receiveSharingPlugin.getPlatformVersion(), '42');
  });
}
