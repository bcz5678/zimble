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
      create: (context) => ReadersCurrentBloc(
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
    return  Column(
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
              if(kDebugMode) {
                print('current_readers_screen -> onPressed -> Entry');
              }
              if (_sensorsActiveToggle == false) {
                if(kDebugMode) {
                  print('current_readers_screen -> onPressed ->false');
                }
                context.read<ReadersCurrentBloc>().add(const StartSensorStream());
              } else {
                if(kDebugMode) {
                  print('current_readers_screen -> onPressed -> true');
                }
                context.read<ReadersCurrentBloc>().add(const StopSensorStream());
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
