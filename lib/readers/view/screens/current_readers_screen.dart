import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/readers/bloc/readers_current/readers_current_bloc.dart';

class CurrentReadersScreen extends StatefulWidget {
  const CurrentReadersScreen({super.key});

  @override
  State<CurrentReadersScreen> createState() => _CurrentReadersScreenState();
}

class _CurrentReadersScreenState extends State<CurrentReadersScreen> {

  late ReaderRepository _readerRepository = context.read<ReaderRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReadersCurrentBloc(
            readerRepository: _readerRepository,
          ),
      child: SensorView(),
    );
  }
}

class SensorView extends StatefulWidget {
  const SensorView({super.key});

  @override
  State<SensorView> createState() => _SensorViewState();
}

class _SensorViewState extends State<SensorView> {
  late bool _sensorsActiveToggle = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AccelerometerReadout(),
        Divider(),
        GyroscopeReadout(),
        Divider(),
        LinearAccelerationReadout(),
        Divider(),
        RotationVectorReadout(),
        Divider(),
        ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                print('current_readers_screen -> onPressed -> Entry');
              }
              if (_sensorsActiveToggle == false) {
                if (kDebugMode) {
                  print('current_readers_screen -> onPressed ->false');
                }
                context.read<ReadersCurrentBloc>().add(
                    const StartSensorStream());
              } else {
                if (kDebugMode) {
                  print('current_readers_screen -> onPressed -> true');
                }
                context.read<ReadersCurrentBloc>().add(
                    const StopSensorStream());
              };

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

class AccelerometerReadout extends StatefulWidget {
  const AccelerometerReadout({super.key});

  @override
  State<AccelerometerReadout> createState() => _AccelerometerReadoutState();
}

class _AccelerometerReadoutState extends State<AccelerometerReadout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadersCurrentBloc, ReadersCurrentState>(
      builder: (context, state) {
        return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Accelerometer'),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('x: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.accelerometerData!.xAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('y: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.accelerometerData!.yAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('z: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.accelerometerData!.zAxis
                          .toString()),
                  ]
              ),
            ]
        );
      },
    );
  }
}

class GyroscopeReadout extends StatefulWidget {
  const GyroscopeReadout({super.key});

  @override
  State<GyroscopeReadout> createState() => _GyroscopeReadoutState();
}

class _GyroscopeReadoutState extends State<GyroscopeReadout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadersCurrentBloc, ReadersCurrentState>(
      builder: (context, state) {
        return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gyroscope'),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('x: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.gyroscopeData!.xAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('y: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.gyroscopeData!.yAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('z: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.gyroscopeData!.zAxis
                          .toString()),
                  ]
              ),
            ]
        );
      },
    );
  }
}

class LinearAccelerationReadout extends StatefulWidget {
  const LinearAccelerationReadout({super.key});

  @override
  State<LinearAccelerationReadout> createState() => _LinearAccelerationReadoutState();
}

class _LinearAccelerationReadoutState extends State<LinearAccelerationReadout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadersCurrentBloc, ReadersCurrentState>(
      builder: (context, state) {
        return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Linear Acceleration'),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('x: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.linearAccelerationData!.xAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('y: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.linearAccelerationData!.yAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('z: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.linearAccelerationData!.zAxis
                          .toString()),
                  ]
              ),
            ]
        );
      },
    );
  }
}

class RotationVectorReadout extends StatefulWidget {
  const RotationVectorReadout({super.key});

  @override
  State<RotationVectorReadout> createState() => _RotationVectorReadoutState();
}

class _RotationVectorReadoutState extends State<RotationVectorReadout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadersCurrentBloc, ReadersCurrentState>(
      builder: (context, state) {
        return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rotation Vector'),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('x: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.rotationVectorData!.xAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('y: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.rotationVectorData!.yAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('z: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.rotationVectorData!.zAxis
                          .toString()),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('scalar: '),
                    if (state.sensorValues == null)
                      Text('0')
                    else
                      Text(state.sensorValues!.rotationVectorData!.scalar
                          .toString()),
                  ]
              ),
            ]
        );
      },
    );
  }
}


