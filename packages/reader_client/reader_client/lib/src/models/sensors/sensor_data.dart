import 'package:equatable/equatable.dart';
import 'package:reader_client/reader_client.dart' show AccelerometerData, GyroscopeData, LinearAccelerationData, RotationVectorData;

class SensorData extends Equatable{
  const SensorData({
    this.accelerometerData,
    this.gyroscopeData,
    this.linearAccelerationData,
    this.rotationVectorData,
  });

  /// The current devices acceleration axis data
  final AccelerometerData? accelerometerData;

  /// The current devices gyroscope axis data
  final GyroscopeData? gyroscopeData;

  /// The current devices linear acceleration axis data
  final LinearAccelerationData? linearAccelerationData;

  /// The current devices rotational vector axis data
  final RotationVectorData? rotationVectorData;

  @override
  List<Object?> get props => [
    accelerometerData,
    gyroscopeData,
    linearAccelerationData,
    rotationVectorData,
  ];
}
