package com.mtg.zimble.sensors.data

import com.google.gson.Gson

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

    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()
        var sensorDataMap = mutableMapOf<String, Any?>(
            "xAxis" to xAxis,
            "yAxis" to yAxis,
            "zAxis" to zAxis,
        )

        map["sensorType"] = "linearAcceleration"
        map["sensorDataMap"] = Gson().toJson(sensorDataMap)

        returnMap.put("sensorData", map)
        return returnMap
    }

    fun toJson(): String {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["sensorType"] = "linearAcceleration"
        map["sensorDataMap"] = mutableMapOf<String, Any?>(
            "xAxis" to xAxis,
            "yAxis" to yAxis,
            "zAxis" to zAxis,
        )

        returnMap.put("sensorData", map)
        return Gson().toJson(returnMap)
    }
}