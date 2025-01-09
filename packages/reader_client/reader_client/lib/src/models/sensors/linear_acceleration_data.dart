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
      xAxis: data['xAxis'] as double,
      yAxis: data['yAxis'] as double,
      zAxis: data['zAxis'] as double,
    );
  }
}
