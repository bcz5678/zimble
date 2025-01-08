import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
   
  factory SensorData.fromJson(Map<String, dynamic> data) {

    /*
    if (kDebugMode) {
      print('sensor_data -> SensorData.fromJson -> data: ${data}');
      print('sensor_data -> SensorData.fromJson -> data["sensorDataMap"]: ${data["sensorDataMap"]}');
    }
    */

    return SensorData(
      accelerometerData: AccelerometerData.fromJson(data['accelerometer'] as Map<String, dynamic>) ?? null
      //gyroscopeData: GyroscopeData.fromJson(data['gyroscope'] as Map<String, dynamic>) ?? null,
      //linearAccelerationData: LinearAccelerationData.fromJson(data['linearAcceleration'] as Map<String, dynamic>) ?? null,
      //rotationVectorData: RotationVectorData.fromJson(data['rotationVector'] as Map<String, dynamic>) ?? null,
    );
  }

  @override
  List<Object?> get props => [
    accelerometerData,
    gyroscopeData,
    linearAccelerationData,
    rotationVectorData,
  ];
}
