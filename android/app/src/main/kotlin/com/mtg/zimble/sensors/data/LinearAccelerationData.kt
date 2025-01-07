package com.mtg.zimble.sensors.data

data class LinearAccelerationData(
    val xAxis: Float,
    val yAxis: Float,
    val zAxis: Float,
) {

    // Convert LinearAccelerationData to standard SensorData class for EventChannel
    fun toSensorData(): SensorData {
        return SensorData(
            sensorType = "linearAcceleration",
            sensorDataMap = mutableMapOf<String, Any?>(
                "xAxis" to xAxis,
                "yAxis" to yAxis,
                "zAxis" to zAxis,
            )
        )
    }
}