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
