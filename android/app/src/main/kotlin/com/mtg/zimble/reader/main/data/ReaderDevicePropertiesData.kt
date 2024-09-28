package com.mtg.zimble.reader.main.data

import kotlin.reflect.full.memberProperties
import com.google.gson.Gson

class ReaderDevicePropertiesData (
    var linkProfile: Int?,
    var maximumCarrierPower: Int?,
    var minimumCarrierPower: Int?,
    var model: String?,
    var isFastIdSupported: Boolean?,
    var isQTModeSupported: Boolean?,
) {

    fun asMap(): Map<String, Any?> {
        return this::class.memberProperties.associate { it.name to it.getter.call(this) }
    }

    fun toJson(): String {
        // Mapping data to JSON for MethodMapCalls
        val gson = Gson()
        return gson.toJson(this)
    }

    companion object {
        /// Mapping From MethodCall JSON object to ReaderTriggerSettingsData
        fun JsonToDeviceProperties(data: Any?): ReaderDevicePropertiesData{
            var devicePropertiesData =
                Gson().fromJson(data as String?, ReaderDevicePropertiesData::class.java)
            return devicePropertiesData
        }
    }

}