package com.mtg.zimble.sensors.data

import com.google.gson.Gson

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

    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()
        var sensorDataMap = mutableMapOf<String, Any?>(
            "xAxis" to xAxis,
            "yAxis" to yAxis,
            "zAxis" to zAxis,
            "scalar" to scalar
        )

        map["sensorType"] = "rotationVector"
        map["sensorDataMap"] = Gson().toJson(sensorDataMap)

        returnMap.put("sensorData", map)
        return returnMap
    }

    fun toJson(): String {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["sensorType"] = "rotationVector"
        map["sensorDataMap"] = mutableMapOf<String, Any?>(
            "xAxis" to xAxis,
            "yAxis" to yAxis,
            "zAxis" to zAxis,
            "scalar" to scalar
        )

        returnMap.put("sensorData", map)
        return Gson().toJson(returnMap)
    }

}
