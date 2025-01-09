class RotationVectorData{
  RotationVectorData({
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

  factory RotationVectorData.fromJson (Map<String, dynamic> data) {
    return RotationVectorData(
      xAxis: data['xAxis'] as double,
      yAxis: data['yAxis'] as double,
      zAxis: data['zAxis'] as double,
      scalar: data['scalar'] as double,
    );
  }
}
