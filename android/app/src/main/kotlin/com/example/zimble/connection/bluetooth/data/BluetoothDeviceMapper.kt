package com.example.zimble.connection.bluetooth.data

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.util.Log
import com.example.zimble.connection.bluetooth.domain.BluetoothDeviceEntity
import com.example.zimble.reader.main.data.ReaderDevicePropertiesData
import com.example.zimble.reader.trigger.data.ReaderTriggerSettingsData

@SuppressLint("MissingPermission")
fun BluetoothDevice.toBluetoothDeviceEntity(): BluetoothDeviceEntity {
    return BluetoothDeviceEntity(
        name = name,
        address = address,
        connectionStatus = null,
        readerDetails = null,
        triggerSettings = null,
    )
}

/// Mapping From MethodCall JSON object to BluetoothDeviceEntity
@SuppressLint("MissingPermission")
fun JsonToBluetoothDeviceEntity(data: Map<String, Any?>): BluetoothDeviceEntity {
    //var readerDetails = Gson().fromJson(data["readerDetails"] as String?, ReaderDevicePropertiesData::class.java).asMap()
    //var triggerSettings = Gson().fromJson(data["triggerSettings"] as String?, ReaderTriggerSettingsData::class.java).asMap()

    Log.d("BT DeviceMapper", data::class.simpleName!!)
    Log.d("BT DeviceMapper", ReaderDevicePropertiesData.JsonToDeviceProperties(data["readerDetails"]!!)::class.simpleName!!)
    Log.d("BT DeviceMapper", ReaderTriggerSettingsData.JsonToTriggerSettings(data["triggerSettings"]!!)::class.simpleName!!)


    return BluetoothDeviceEntity(
        name =  data["name"] as String?,
        address =  if(data.containsKey("address"))  data["address"] as String  else  data["MACaddress"] as String,
        connectionStatus =  data["connectionStatus"] as String?,
        //Casting (with GSON) the readerDetails to a Map from string (invokeMapMethod doesn't allow nested Maps)
        //readerDetails = Gson().fromJson(data["readerDetails"] as String?, ReaderDevicePropertiesData::class.java).asMap(),
        //triggerSettings = Gson().fromJson(data["triggerSettings"] as String?, ReaderTriggerSettingsData::class.java).asMap(),
        readerDetails = if(data["readerDetails"] != null) ReaderDevicePropertiesData.JsonToDeviceProperties(data["readerDetails"]!!) else null,
        triggerSettings = if(data["triggerSettings"] != null) ReaderTriggerSettingsData.JsonToTriggerSettings(data["triggerSettings"]!!) else null,
    )
}

/*
/// Defining a GSON method to convert string maps from method messages to Map<String, Any?>
/// Must pass String and Full java Data class to convert to (i.e. ReaderDetailsData::class.java)
fun jsonStringToMapWithGson(jsonString: String?): Map<String, Any?> {
    if(jsonString == "{}") {
        return emptyMap()
    } else {
        val classType: Type = object : TypeToken<Map<String, Any?>>() {}.type
        val jsonToReturn = Gson().fromJson(jsonString, classType)
        Log.d("BluetoothDeviceMapper", "${jsonToReturn::class.simpleName}")
        return jsonToReturn
    }
}
*/