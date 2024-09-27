package com.example.untitled.reader.main.data

import com.example.untitled.reader.trigger.data.ReaderTriggerSettingsData

data class ReaderEntityData(
    var name: String?,
    var address: String,
    var connectionStatus: String?,
    var readerDetails: ReaderDevicePropertiesData?,
    var triggerSettings: ReaderTriggerSettingsData?,
)