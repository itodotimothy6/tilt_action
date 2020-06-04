import 'dart:async';
import 'package:sensors/sensors.dart';

typedef VoidCallback = void Function();

enum TiltPosition {
  up,
  down,
  normal,
}

class Tilt {
  final VoidCallback onTiltUp;
  final VoidCallback onTiltDown;
  final VoidCallback onNormal;
  final double offset;

  StreamSubscription streamSubscription;
  TiltPosition currentTiltPosition;

  var positionChangedTimeStamp = DateTime.now().millisecondsSinceEpoch;

  Tilt({this.onTiltUp, this.onTiltDown, this.onNormal, this.offset = 2.0}) {
    startListening();
  }

  void startListening() {
    const double gravity = 9.80665;

    streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double z = event.z;
      double zNegative = -1 * z;

      var now = DateTime.now().millisecondsSinceEpoch;
      if (now - positionChangedTimeStamp >= 1000) {
        if ((z - gravity).abs() < offset) {
          callCallback(onTiltUp, TiltPosition.up);
        } else if ((zNegative - gravity).abs() < offset) {
          callCallback(onTiltDown, TiltPosition.down);
        } else {
          callCallback(onNormal, TiltPosition.normal);
        }
      }
    });
  }

  void callCallback(VoidCallback callback, TiltPosition tiltPosition) {
    if (currentTiltPosition != tiltPosition) {
      currentTiltPosition = tiltPosition;
      callback();
      positionChangedTimeStamp = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void stopListening() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }
}
