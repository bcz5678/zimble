package com.mtg.zimble.reader.tags.data

import com.google.gson.Gson

class TransponderData (
    var epc: String,
    var tidData: String?,
    var rssi: Int?,
    var rssiPercent: Int?,
    var pc: Int?,
    var crc: Int?,
    var qt: Int?,
    var didKill: Boolean?,
    var didLock: Boolean?,
    var channelFrequency: Int?,
    var phase: Int?,
    var timestamp: String?,
    var index: Int?,
    var accessErrorCode: String?,
    var backscatterErrorCode: String?,
    var readData: String?,
    var wordsWritten: Int?,
    var isDuplicate: Boolean?,
){

    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()
        var tagDataMap = mutableMapOf<String, Any?>(
            "epc" to epc,
            "tid" to tidData,
            "rssi" to rssi,
            "rssiPercent" to rssiPercent,
            "pc" to pc,
            "crc" to crc,
            "qt" to qt,
            "didKill" to didKill,
            "didLock" to didLock,
            "channelFrequency" to channelFrequency,
            "phase" to phase,
            "timestamp" to timestamp,
            "index" to index,
            "accessErrorCode" to accessErrorCode,
            "backscatterErrorCode" to backscatterErrorCode,
            "readData" to readData,
            "wordsWritten" to wordsWritten,
            "isDuplicate" to isDuplicate,
        )

        map["tagData"] = Gson().toJson(tagDataMap)
        return returnMap
    }

    fun toJson(): String {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["tagDataMap"] = mutableMapOf<String, Any?>(
            "epc" to epc,
            "tid" to tidData,
            "rssi" to rssi,
            "rssiPercent" to rssiPercent,
            "pc" to pc,
            "crc" to crc,
            "qt" to qt,
            "didKill" to didKill,
            "didLock" to didLock,
            "channelFrequency" to channelFrequency,
            "phase" to phase,
            "timestamp" to timestamp,
            "index" to index,
            "accessErrorCode" to accessErrorCode,
            "backscatterErrorCode" to backscatterErrorCode,
            "readData" to readData,
            "wordsWritten" to wordsWritten,
            "isDuplicate" to isDuplicate,
        )

        returnMap.put("tagData", map)
        return Gson().toJson(returnMap)
    }
}