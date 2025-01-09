class AccelerometerData{
  AccelerometerData({
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

  factory AccelerometerData.fromJson (Map<String, dynamic> data) {
    return AccelerometerData(
      xAxis: data['xAxis'] as double,
      yAxis: data['yAxis'] as double,
      zAxis: data['zAxis'] as double,
    );
  }
}
