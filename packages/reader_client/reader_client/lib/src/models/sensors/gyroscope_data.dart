class GyroscopeData{
  GyroscopeData({
    this.xAxis,
    this.yAxis,
    this.zAxis,
  });

  /// Rate of rotation around the x axis (rad/s)
  late double? xAxis;

  /// Rate of rotation around the y axis (rad/s)
  late double? yAxis;

  /// Rate of rotation around the z axis (rad/s)
  late double? zAxis;

  factory GyroscopeData.fromJson (Map<String, dynamic> data) {
    return GyroscopeData(
      xAxis: data['xAxis'] as double,
      yAxis: data['yAxis'] as double,
      zAxis: data['zAxis'] as double,
    );
  }
}
