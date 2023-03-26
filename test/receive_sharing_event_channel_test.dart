import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receive_sharing/receive_sharing_method_channel.dart';

void main() {
  MethodChannelReceiveSharing platform = MethodChannelReceiveSharing();
  const EventChannel eventChannel = EventChannel("receive_sharing/events");
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    MethodChannel(eventChannel.name).setMockMethodCallHandler((call) async {
      final messenger = ServicesBinding.instance.defaultBinaryMessenger;
      await messenger.handlePlatformMessage(eventChannel.name,
          eventChannel.codec.encodeSuccessEnvelope({"text": "text"}), (_) {});
    });
  });

  test("receive", () async {
    expect(
      platform.eventChannel.receiveBroadcastStream(),
      emitsInOrder([
        {"text": "text"}
      ]),
    );
  });
}
