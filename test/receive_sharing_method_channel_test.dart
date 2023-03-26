import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receive_sharing/receive_sharing_method_channel.dart';

void main() {
  MethodChannelReceiveSharing platform = MethodChannelReceiveSharing();
  const MethodChannel channel = MethodChannel('receive_sharing');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
