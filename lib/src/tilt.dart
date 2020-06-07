import 'dart:async';
import 'package:sensors/sensors.dart';

typedef VoidCallback = void Function();

/// The three possible positions
enum TiltPosition {
  up,
  down,
  normal,
}

class Tilt {
  /// User callback when phone is tilted up
  final VoidCallback onTiltUp;

  /// User callback when phone is tilted down
  final VoidCallback onTiltDown;

  /// User callback when phone is in normal position
  final VoidCallback onNormal;

  /// This is a measure of how precise the position is
  ///
  /// If offset = 0, [onTiltUp] & [onTiltDown] will only be called when the
  /// phone is perfectly horizontal.
  /// The default value is 2.0
  final double offset;

  /// This is the minimum wait time before listening for another events
  ///
  /// Default value is 1000 ms
  final int eventWaitTimeMS;

  /// Stream subscription for [accelerometerEvents]
  StreamSubscription _streamSubscription;

  /// Current Tilt position of the phone
  TiltPosition _currentTiltPosition;

  var positionChangedTimeStamp = DateTime.now().millisecondsSinceEpoch;

  /// This constructor starts listening for for [accelerometerEvents] immediately
  /// the object is created
  Tilt({
    this.onTiltUp,
    this.onTiltDown,
    this.onNormal,
    this.offset = 2.0,
    this.eventWaitTimeMS = 1000,
  }) {
    startListening();
  }

  /// This constructor waits until [startListening] is called before listening
  /// for events
  Tilt.waitForStart({
    this.onTiltUp,
    this.onTiltDown,
    this.onNormal,
    this.offset = 2.0,
    this.eventWaitTimeMS = 1000,
  });

  /// Starts listening for accelerometer events
  void startListening() async {
    const double gravity = 9.80665;

    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double z = event.z;
      double zNegative = -1 * z;

      var now = DateTime.now().millisecondsSinceEpoch;

      if (now - positionChangedTimeStamp >= eventWaitTimeMS) {
        if ((z - gravity).abs() < offset) {
          _callCallback(onTiltUp, TiltPosition.up);
        } else if ((zNegative - gravity).abs() < offset) {
          _callCallback(onTiltDown, TiltPosition.down);
        } else {
          _callCallback(onNormal, TiltPosition.normal);
        }
      }
    });
  }

  /// This function ensures that a position's callback is not called again,
  /// until after the tilt position has been changed
  void _callCallback(VoidCallback callback, TiltPosition tiltPosition) {
    if (_currentTiltPosition != tiltPosition) {
      _currentTiltPosition = tiltPosition;
      callback();
      positionChangedTimeStamp = DateTime.now().millisecondsSinceEpoch;
    }
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    _streamSubscription?.cancel();
  }
}
