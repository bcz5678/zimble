package com.mtg.zimble.sensors.data

data class GyroscopeData(
    val xAxis: Float,
    val yAxis: Float,
    val zAxis: Float,
) {

    // Convert GyroscopeData to standard SensorData class for EventChannel
    fun toSensorData(): SensorData {
        return SensorData(
            sensorType = "gyroscope",
            sensorDataMap = mutableMapOf<String, Any?>(
                "xAxis" to xAxis,
                "yAxis" to yAxis,
                "zAxis" to zAxis,
            )
        )
    }
}