package com.mtg.zimble.connection.bluetooth.data

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.util.Log
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceEntity
import com.mtg.zimble.reader.main.data.ReaderDevicePropertiesData
import com.mtg.zimble.reader.trigger.data.ReaderTriggerSettingsData

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