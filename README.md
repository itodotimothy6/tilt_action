# tilt_action

Flutter package that triggers action depending on the tilt position of a phone. The possible positions are tilted up, tilted down or not tilted.

## Getting Started
To use this package add tilt_action to your as a [dependency to your pubsec.yaml](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Example
Testing on a physical device is highly recommended
```
class _TiltActionDemoState extends State<TiltActionDemo> {
  String text;
  Tilt tilt;

  @override
  void initState() {
    super.initState();

    tilt = Tilt(onTiltUp: () {
      setState(() {
        text = "I am tilted Up";
      });
    }, onTiltDown: () {
      setState(() {
        text = "I am tilted Down";
      });
    }, onNormal: () {
      setState(() {
        text = "Neither Up or Down";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    
    tilt.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(text),
        ),
      ),
    );
  }
}
```
