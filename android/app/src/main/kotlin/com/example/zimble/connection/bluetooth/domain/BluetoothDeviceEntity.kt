package com.example.zimble.connection.bluetooth.domain

import com.example.zimble.reader.main.data.ReaderDevicePropertiesData
import com.example.zimble.reader.trigger.data.ReaderTriggerSettingsData

class BluetoothDeviceEntity(
    var name: String?,
    var address: String,
    var connectionStatus: String?,
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
}