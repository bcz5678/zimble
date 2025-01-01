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

  /// Acceleration force along the x axis, including gravity (m/s*2)
  late double? xAxis;

  /// Acceleration force along the y axis, including gravity (m/s*2)
  late double? yAxis;

  /// Acceleration force along the z axis, including gravity (m/s*2)
  late double? zAxis;

  factory AccelerationData.fromJson (Map<String, dynamic> data) {
    return AccelerationData(
      xAxis: data['x'] as double,
      yAxis: data['y'] as double,
      zAxis: data['z'] as double,
    );
  }
}

class GyroscopeData{
  GyroscopeData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
  });

  /// Rate of rotation around the x axis (rad/s)
  late int? xAxis;

  /// Rate of rotation around the y axis (rad/s)
  late int? yAxis;

  /// Rate of rotation around the z axis (rad/s)
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

  /// Acceleration force along the x axis, excluding gravity (m/s*2)
  late double? xAxis;

  /// Acceleration force along the y axis, excluding gravity (m/s*2)
  late double? yAxis;

  /// Acceleration force along the z axis, excluding gravity (m/s*2)
  late double? zAxis;

  factory LinearAccelerationData.fromJson (Map<String, dynamic> data) {
    return LinearAccelerationData(
      xAxis: data['x'] as double,
      yAxis: data['y'] as double,
      zAxis: data['z'] as double,
    );
  }
}

class RotationalVectorData{
  RotationalVectorData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
    this.scalar,
  });

  /// Rotation vector component along the x axis (x * sin(θ/2)).
  late double? xAxis;

  /// Rotation vector component along the y axis (y * sin(θ/2)).
  late double? yAxis;

  /// Rotation vector component along the y axis (y * sin(θ/2)).
  late double? zAxis;

  /// Scalar component of the rotation vector ((cos(θ/2)).
  late double? scalar;

  factory RotationalVectorData.fromJson (Map<String, dynamic> data) {
    return RotationalVectorData(
      xAxis: data['x'] as double,
      yAxis: data['y'] as double,
      zAxis: data['z'] as double,
      scalar: data['scalar'] as double,
    );
  }
}
