import 'package:flutter/material.dart';

class CurrentReadersScreen extends StatefulWidget {
  const CurrentReadersScreen({super.key});

  @override
  State<CurrentReadersScreen> createState() => _CurrentReadersScreenState();
}

class _CurrentReadersScreenState extends State<CurrentReadersScreen> {
  late bool _sensorsActiveToggle = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SensorReadout(
            sensorType: "Accelerometer"
        ),
        SensorReadout(
            sensorType: "Gyroscope"
        ),
        SensorReadout(
            sensorType: "Linear Acceleration"
        ),
        SensorReadout(
            sensorType: "Rotation Vector"
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _sensorsActiveToggle = !_sensorsActiveToggle;
              });
            },
            child: _sensorsActiveToggle
                ? Text("Stop Sensors")
                : Text("Start Sensors")
        )
      ],
    );
  }
}


class SensorReadout extends StatefulWidget {
  SensorReadout({
    required this.sensorType,
    super.key
  });

  late String sensorType;

  @override
  State<SensorReadout> createState() => _SensorReadoutState();
}

class _SensorReadoutState extends State<SensorReadout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${widget.sensorType}:  '),
        Text('0'),
      ]
    );
  }
}
