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

    companion object {
        /// Function to build the TagData object from a MutableMap
        /// (usually received from the reader in the AndroidTagController)
        fun fromMap(tagDataMap: MutableMap<String, Any?>): TagData {
            return TagData(
                epc = tagDataMap["epc"].toString(),
                tidData = tagDataMap["tidData"] as String?,
                rssi = tagDataMap["rssi"] as Int?,
                rssiPercent = tagDataMap["rssiPercent"] as Int?,
                pc = tagDataMap["pc"] as Int?,
                crc = tagDataMap["crc"] as Int?,
                qt = tagDataMap["qt"] as Int?,
                didKill = tagDataMap["didKill"] as Boolean?,
                didLock = tagDataMap["didLock"] as Boolean?,
                channelFrequency = tagDataMap["channelFrequency"] as Int?,
                phase = tagDataMap["phase"] as Int?,
                timestamp = tagDataMap["timestamp"] as String?,
                index = tagDataMap["index"] as Int?,
                accessErrorCode = tagDataMap["accessErrorCode"] as String?,
                backscatterErrorCode = tagDataMap["backscatterErrorCode"] as String?,
                readData = tagDataMap["readData"] as String?,
                wordsWritten = tagDataMap["wordsWritten"] as Int?,
                isDuplicate = tagDataMap["isDuplicate"] as Boolean?,
            )
        }
    }

}