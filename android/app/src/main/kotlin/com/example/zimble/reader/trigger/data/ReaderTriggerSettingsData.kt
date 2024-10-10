package com.example.zimble.reader.trigger.data

import android.annotation.SuppressLint
import android.util.Log
import com.example.zimble.connection.bluetooth.domain.BluetoothDeviceEntity
import com.example.zimble.reader.main.data.ReaderDevicePropertiesData
import com.uk.tsl.rfid.asciiprotocol.enumerations.TriState
import com.uk.tsl.rfid.asciiprotocol.enumerations.SwitchAction

import com.google.gson.Gson

import kotlin.reflect.full.memberProperties

class ReaderTriggerSettingsData (
    var asyncReportingEnabled: TriState?,
    var pollingReportingEnabled: Boolean?,
    var doublePressAction: SwitchAction?,
    var doublePressRepeatDelay: Int?,
    var hapticFeedbackEnabled: TriState?,
    var readParameters: TriState?,
    var resetParameters: TriState?,
    var singlePressAction: SwitchAction?,
    var singlePressRepeatDelay: Int?,
    var takeNoAction: TriState?,
    var implementsReadParameters: Boolean?,
    var implementsResetParameters: Boolean?,
    var implementsTakeNoAction: Boolean?,
    //var maximumRepeatDelay: Int?,
    //var minimumRepeatDelay: Int?,
) {

    fun asMap(): Map<String, Any?> {
        return this::class.memberProperties.associate { it.name to it.getter.call(this) }
    }

    fun toJson(): String {
        val gson = Gson()
        return gson.toJson(this)
    }

    companion object {
        /// Mapping From MethodCall JSON object to ReaderTriggerSettingsData
        fun JsonToTriggerSettings(data: Any?): ReaderTriggerSettingsData {
            var triggerSettings =
                Gson().fromJson(data as String?, ReaderTriggerSettingsData::class.java)
            return triggerSettings
        }
    }
}


