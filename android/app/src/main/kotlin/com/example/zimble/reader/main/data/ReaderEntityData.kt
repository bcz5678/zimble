package com.example.zimble.reader.main.data

import com.example.zimble.reader.trigger.data.ReaderTriggerSettingsData

data class ReaderEntityData(
    var name: String?,
    var address: String,
    var connectionStatus: String?,
    var readerDetails: ReaderDevicePropertiesData?,
    var triggerSettings: ReaderTriggerSettingsData?,
)