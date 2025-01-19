package com.mtg.zimble.connection.bluetooth.domain
import kotlinx.coroutines.flow.*

interface BluetoothController {
    val isConnected: StateFlow<Boolean>
    val scannedDevices: StateFlow<List<BluetoothDeviceEntity>>
    val pairedDevices: StateFlow<List<BluetoothDeviceEntity>>
    val errors: SharedFlow<String>

    fun startDiscovery(streamHandlerInstanceTest: BluetoothDeviceScanningStreamHandler)
    fun stopDiscovery()

    //fun startBluetoothServer(): Flow<ConnectionResult>

    fun connectToDevice(device: BluetoothDeviceEntity): Boolean

    fun disconnectFromDevice(device: BluetoothDeviceEntity): Boolean

    fun closeConnection()

    fun release()
}