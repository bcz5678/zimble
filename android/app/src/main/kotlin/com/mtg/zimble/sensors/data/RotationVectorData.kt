package com.mtg.zimble.sensors.data

data class RotationVectorData(
    val xAxis: Float,
    val yAxis: Float,
    val zAxis: Float,
    val scalar: Float,
) {

    // Convert RotationVectorData to standard SensorData class for EventChannel
    fun toSensorData(): SensorData {
        return SensorData(
            sensorType = "rotationVector",
            sensorDataMap = mutableMapOf<String, Any?>(
                "xAxis" to xAxis,
                "yAxis" to yAxis,
                "zAxis" to zAxis,
                "scalar" to scalar
            )
        )
    }
}
