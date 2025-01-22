package com.mtg.zimble.reader.tags.data

import com.google.gson.Gson

class BarcodeData (
    var data: String?,
    var timestamp: String?,
    var symbologyCode: String?,
    var symbologyModifier: String?,
    var symbologyName: String?

) {

    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()
        var barcodeDataMap = mutableMapOf<String, Any?>(
            "data" to data,
            "timestamp" to timestamp,
            "symbologyCode" to symbologyCode,
            "symbologyModifier" to symbologyModifier,
            "symbologyName" to symbologyName,
        )
        map["barcodeData"] = Gson().toJson(barcodeDataMap)
        return returnMap
    }

    fun toJson(): String {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["barcodeDataMap"] = mutableMapOf<String, Any?>(
            "data" to data,
            "timestamp" to timestamp,
            "symbologyCode" to symbologyCode,
            "symbologyModifier" to symbologyModifier,
            "symbologyName" to symbologyName,
        )

        returnMap.put("barcodeData", map)
        return Gson().toJson(returnMap)
    }

}