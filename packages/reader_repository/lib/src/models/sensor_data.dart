import 'package:equatable/equatable.dart';

class SensorData extends Equatable{
  const SensorData({
    this.accelerationData,
    this.gyroscopeData,
    this.linearAccelerationData,
    this.rotationalVectorData,
  });

  /// The current devices acceleration axis data
  final AccelerationData? accelerationData;

  /// The current devices gyroscope axis data
  final GyroscopeData? gyroscopeData;

  /// The current devices linear acceleration axis data
  final LinearAccelerationData? linearAccelerationData;

  /// The current devices rotational vector axis data
  final RotationalVectorData? rotationalVectorData;


  @override
  List<Object?> get props => [
    accelerationData,
    gyroscopeData,
    linearAccelerationData,
    rotationalVectorData,
  ];
}


class AccelerationData{
  AccelerationData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
  });

  /// X-Axis data returned from method
  late int? xAxis;

  /// X-Axis data returned from method
  late int? yAxis;

  /// X-Axis data returned from method
  late int? zAxis;

  factory AccelerationData.fromJson (Map<String, dynamic> data) {
    return AccelerationData(
      xAxis: data['x'] as int,
      yAxis: data['y'] as int,
      zAxis: data['z'] as int,
    );
  }
}

class GyroscopeData{
  GyroscopeData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
  });

  /// X-Axis data returned from method
  late int? xAxis;

  /// X-Axis data returned from method
  late int? yAxis;

  /// X-Axis data returned from method
  late int? zAxis;

  factory GyroscopeData.fromJson (Map<String, dynamic> data) {
    return GyroscopeData(
      xAxis: data['x'] as int,
      yAxis: data['y'] as int,
      zAxis: data['z'] as int,
    );
  }
}

class LinearAccelerationData{
  LinearAccelerationData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
  });

  /// X-Axis data returned from method
  late int? xAxis;

  /// X-Axis data returned from method
  late int? yAxis;

  /// X-Axis data returned from method
  late int? zAxis;

  factory LinearAccelerationData.fromJson (Map<String, dynamic> data) {
    return LinearAccelerationData(
      xAxis: data['x'] as int,
      yAxis: data['y'] as int,
      zAxis: data['z'] as int,
    );
  }
}

class RotationalVectorData{
  RotationalVectorData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
  });

  /// X-Axis data returned from method
  late int? xAxis;

  /// X-Axis data returned from method
  late int? yAxis;

  /// X-Axis data returned from method
  late int? zAxis;

  factory RotationalVectorData.fromJson (Map<String, dynamic> data) {
    return RotationalVectorData(
      xAxis: data['x'] as int,
      yAxis: data['y'] as int,
      zAxis: data['z'] as int,
    );
  }
}