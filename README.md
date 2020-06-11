# tilt_action

Flutter package that triggers action depending on the tilt position of a phone. The possible positions are tilted up, tilted down or not tilted.

## Getting Started
To use this package add tilt_action to your as a [dependency to your pubsec.yaml](https://flutter.dev/docs/development/packages-and-plugins/using-packages). Testing on a physical device is highly recommended

## Usage

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
The above constructor starts listening for movement immediately it is declared. To choose when to start listening, use the constructor below instead.

```
Tilt tilt = Tilt.waitForStart(
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
....
tilt.startListening()
```

You can also modify the precision & the amount of time gap for listening for movements. For example:
```
Tilt tilt = Tilt(
      offset: 0,
      eventWaitTimeMS: 2000,
      onTiltUp: () {
        // print('Phone is perfectly horizontal');
      },
    );
```
In the example above, ```onTiltUp()``` will only be called when the phone is perfectly horizantal and the screen is upwards. This is because the offset is set to ```0```. Also, tilt will check for changes in position every 2 seconds because ```eventWaitTimeMS``` is set to ```2000``` ms. 



**[Full example](https://pub.dev/packages/tilt_action#-example-tab-)**

