package com.mtg.zimble.connection.bluetooth.domain

import com.mtg.zimble.reader.main.data.ReaderDevicePropertiesData
import com.mtg.zimble.reader.trigger.data.ReaderTriggerSettingsData

import com.google.gson.Gson



class BluetoothDeviceEntity(
    var name: String?,
    var address: String,
    var connectionStatus: Boolean?,
    var readerDetails: ReaderDevicePropertiesData?,
    var triggerSettings: ReaderTriggerSettingsData?,
) {

    //Convert BluetoothDeviceEntity to Map Object
    fun toMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()

        map["name"] = name
        map["address"] = address
        map["connectionStatus"] = connectionStatus
        map["readerDetails"] = readerDetails
        map["triggerSettings"] = triggerSettings

        return map
    }

    //Convert BluetoothDeviceEntity to Map for send with MethodMessageData
    fun toMessageMap(): MutableMap<String, Any?> {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["name"] = name
        map["address"] = address
        map["connectionStatus"] = connectionStatus
        map["readerDetails"] = readerDetails?.toJson()
        map["triggerSettings"] = triggerSettings?.toJson()

        returnMap.put("bluetoothDeviceEntity", map)
        return returnMap
    }

    fun toJson(): String {
        var map = mutableMapOf<String, Any?>()
        var returnMap = mutableMapOf<String, Any?>()

        map["name"] = name
        map["address"] = address
        map["connectionStatus"] = connectionStatus
        map["readerDetails"] = readerDetails?.toJson()
        map["triggerSettings"] = triggerSettings?.toJson()

        returnMap.put("bluetoothDeviceEntity", map)
        return Gson().toJson(returnMap)
    }

    companion object {
        //Constructor to map from Json object
        fun fromJson(jsonData: Map<String, Any?>): BluetoothDeviceEntity {
            return BluetoothDeviceEntity(
                name = jsonData["name"] as String?,
                address = jsonData["macAddress"] as String,
                connectionStatus = jsonData["connectionStatus"] as Boolean?,
                readerDetails = jsonData["readerDetails"] as ReaderDevicePropertiesData?,
                triggerSettings = jsonData["triggerSettings"] as ReaderTriggerSettingsData?,
            )
        }
    }
}