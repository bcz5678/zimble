package com.mtg.zimble.reader.tags.data

import com.google.gson.Gson

class TagScanData (
    var epc: String,
    var tidData: String?,
    var rssi: Int?,
    var pc: Int?,
    var crc: Int?,
    var channelFrequency: Int?,
){
    /// Function to build a MessageMap from the TagData object to send across the EventChannel
    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()
        var tagDataMap = mutableMapOf<String, Any?>(
            "epc" to epc,
            "tid" to tidData,
            "rssi" to rssi,
            "pc" to pc,
            "crc" to crc,
            "channelFrequency" to channelFrequency,
        )
        map["tagScanData"] = Gson().toJson(tagDataMap)
        return returnMap
    }

    /// Function to build a Json String from the TagData object
    ///  to send across the EventChannel or to remote API
    fun toJson(): String {
        var returnMap = mutableMapOf<String, Any?>()
        //var returnMap = mutableMapOf<String, Any?>()

        returnMap["tagScanData"] = mutableMapOf<String, Any?>(
            "epc" to epc,
            "tid" to tidData,
            "rssi" to rssi,
            "pc" to pc,
            "crc" to crc,
            "channelFrequency" to channelFrequency,
        )

        //returnMap.put("tagData", map)
        return Gson().toJson(returnMap)
    }

    companion object {
        /// Function to build an Initial TagData object for the Stateflow (since it cant have
        /// a null starting value and will be EPC = INITIAL and ignored by the collector
        fun  initial(): TagScanData {
            return TagScanData(
                epc = "INITIAL",
                tidData = null,
                rssi = null,
                pc = null,
                crc = null,
                channelFrequency = null,
            )
        }


        /// Function to build the TagData object from a MutableMap
        /// (usually received from the reader in the AndroidTagController)
        fun fromMap(tagDataMap: MutableMap<String, Any?>): TagScanData {
            return TagScanData(
                epc = tagDataMap["epc"].toString(),
                tidData = tagDataMap["tidData"] as String?,
                rssi = tagDataMap["rssi"] as Int?,
                pc = tagDataMap["pc"] as Int?,
                crc = tagDataMap["crc"] as Int?,
                channelFrequency = tagDataMap["channelFrequency"] as Int?,
            )
        }
    }
}