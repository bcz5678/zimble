package com.mtg.zimble.sensors.data

class AccelerometerData(
    var xAxis: Float,
    var yAxis: Float,
    var zAxis: Float,
) {

    // Convert AccelerometerData to standard SensorData class for EventChannel
    fun toSensorData(): SensorData {
        return SensorData(
            sensorType = "accelerometer",
            sensorDataMap = mutableMapOf<String, Any?>(
                "xAxis" to xAxis,
                "yAxis" to yAxis,
                "zAxis" to zAxis,
            )
        )
    }
}