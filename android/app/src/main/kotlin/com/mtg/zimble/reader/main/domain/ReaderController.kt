package com.mtg.zimble.reader.main.domain

import android.content.Context
import com.mtg.zimble.reader.main.data.ReaderDevicePropertiesData
import io.flutter.plugin.common.BinaryMessenger
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceEntity


interface ReaderController {

    fun setupReaderManager(context: Context, messenger: BinaryMessenger): Unit

    fun getBTReaderList(): Unit

    fun getConnectedReaderName(): String?

    fun setupReaderChannels(context: Context, messenger: BinaryMessenger): Unit

    fun getReaderInfoByMAC(device: BluetoothDeviceEntity): Map<String, Any?>

    fun getReaderInfoByIndex(deviceIndex: Int): Map<String, Any?>

    fun getReaderIndexByMAC(device: BluetoothDeviceEntity): Int?

    fun getAllDeviceProperties(): Map<String, Any?>

    fun getReaderDeviceProperties(): ReaderDevicePropertiesData

    fun connectToSDKReader(device: BluetoothDeviceEntity): Boolean

    fun disconnectFromReader(device: BluetoothDeviceEntity): Boolean

    fun teardownReaderHandlers()
}