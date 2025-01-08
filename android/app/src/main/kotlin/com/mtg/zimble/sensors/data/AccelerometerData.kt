package com.mtg.zimble.sensors.data

import com.google.gson.Gson


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

    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()
        var sensorDataMap = mutableMapOf<String, Any?>(
            "xAxis" to xAxis,
            "yAxis" to yAxis,
            "zAxis" to zAxis,
        )

        map["sensorType"] = "accelerometer"
        map["sensorDataMap"] = Gson().toJson(sensorDataMap)

        returnMap.put("sensorData", map)
        return returnMap
    }

    fun toJson(): String {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["sensorType"] = "accelerometer"
        map["sensorDataMap"] = mutableMapOf<String, Any?>(
            "xAxis" to xAxis,
            "yAxis" to yAxis,
            "zAxis" to zAxis,
        )

        returnMap.put("sensorData", map)
        return Gson().toJson(returnMap)
    }
}
