# tilt_action

Flutter package that triggers action depending on the tilt position of a phone. The possible positions are tilted up, tilted down or not tilted.

## Getting Started
To use this package add tilt_action to your as a [dependency to your pubsec.yaml](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Example

```
Tilt tilt = Tilt(
  onTiltUp: () {
    // When phone is tilted up, do this
  },
  onNormal: () {
    // When phone is neither up nor down, do this
  },
  onTiltDown: () {
    // When phone is tilted down, do this
  },
);
```

Testing on a physical device is highly recommended

**[Full example](https://github.com/itodotimothy6/tilt_action/blob/master/example/lib/main.dart)**

