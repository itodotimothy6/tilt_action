import 'package:flutter/material.dart';
import 'package:tilt_action/tilt_action.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Tap Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TiltActionDemo(),
    );
  }
}

class TiltActionDemo extends StatefulWidget {
  @override
  _TiltActionDemoState createState() => _TiltActionDemoState();
}

class _TiltActionDemoState extends State<TiltActionDemo> {
  String text =
      "Test on a physical device. Sensors don't work accurately on emulators/simulators";
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
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
