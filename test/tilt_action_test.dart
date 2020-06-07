import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:test/test.dart';

import 'package:tilt_action/src/tilt.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TiltPosition position;
  const gravity = 9.80665;

  test('Phone is tilted up', () async {
    const String channelName = 'plugins.flutter.io/sensors/accelerometer';
    const List<double> sensorData = <double>[0.0, 0.0, gravity];
    _initializeFakeSensorChannel(channelName, sensorData);

    Tilt tilt = Tilt(
      eventWaitTimeMS: 0,
      onNormal: () {
        position = TiltPosition.normal;
      },
      onTiltUp: () {
        position = TiltPosition.up;
      },
      onTiltDown: () {
        position = TiltPosition.down;
      },
    );

    await Future.delayed(const Duration(milliseconds: 1000), () {});
    expect(position, TiltPosition.up);
    tilt.stopListening();
  });

  test('Phone is tilted down', () async {
    const String channelName = 'plugins.flutter.io/sensors/accelerometer';
    const List<double> sensorData = <double>[0.0, 0.0, -gravity];
    _initializeFakeSensorChannel(channelName, sensorData);

    Tilt tilt = Tilt(
      eventWaitTimeMS: 0,
      onNormal: () {
        position = TiltPosition.normal;
      },
      onTiltUp: () {
        position = TiltPosition.up;
      },
      onTiltDown: () {
        position = TiltPosition.down;
      },
    );

    await Future.delayed(const Duration(milliseconds: 1000), () {});
    expect(position, TiltPosition.down);
    tilt.stopListening();
  });

  test('Phone is neither up nor down', () async {
    const String channelName = 'plugins.flutter.io/sensors/accelerometer';
    const List<double> sensorData = <double>[1.0, 2.0, 6.8];
    _initializeFakeSensorChannel(channelName, sensorData);

    Tilt tilt = Tilt(
      eventWaitTimeMS: 0,
      onNormal: () {
        position = TiltPosition.normal;
      },
      onTiltUp: () {
        position = TiltPosition.up;
      },
      onTiltDown: () {
        position = TiltPosition.down;
      },
    );

    await Future.delayed(const Duration(milliseconds: 1000), () {});
    expect(position, TiltPosition.down);
    tilt.stopListening();
  });
}

void _initializeFakeSensorChannel(String channelName, List<double> sensorData) {
  const StandardMethodCodec standardMethod = StandardMethodCodec();

  void _emitEvent(ByteData event) {
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      event,
      (ByteData reply) {},
    );
  }

  ServicesBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData message) async {
    final MethodCall methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == 'listen') {
      _emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
      _emitEvent(null);
      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}
