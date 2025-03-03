package com.mtg.zimble.reader.tags.data

import com.google.gson.Gson

class TagData (
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

    /// Function to build the TagData objject from a MutableMap
    /// (usually received from the reader in the AndroidTagController)
    fun fromMap(tagDataMap: MutableMap<String, Any?>): TagData {
        return TagData(
            epc: tagDataMap["epc"],
            tidData: tagDataMap["tidData"] ?: null,
            rssi: tagDataMap["rssi"] ?: null,
            rssiPercent: tagDataMap["rssiPercent"] ?: null,
            pc: tagDataMap["pc"] ?: null,
            crc: tagDataMap["crc"] ?: null,
            qt: tagDataMap["qt"] ?: null,
            didKill: tagDataMap["didKill"] ?: null,
            didLock: tagDataMap["didLock"] ?: null,
            channelFrequency: tagDataMap["channelFrequency"] ?: null,
            phase: tagDataMap["phase"] ?: null,
            timestamp: tagDataMap["timestamp"] ?: null,
            index: tagDataMap["index"] ?: null,
            accessErrorCode: tagDataMap["accessErrorCode"] ?: null,
            backscatterErrorCode: tagDataMap["backscatterErrorCode"] ?: null,
            readData: tagDataMap["readData"] ?: null,
            wordsWritten: tagDataMap["wordsWritten"] ?: null,
            isDuplicate: tagDataMap["isDuplicate"] ?: null,
        )
    }

    /// Function to build a MessageMap from the TagData object to send across the EventChannel
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

    /// Function to build a Json String from the TagData object
    ///  to send across the EventChannel or to remote API
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