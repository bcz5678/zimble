package com.example.untitled.connection.bluetooth.domain

//import android.content.Context
import io.flutter.plugin.common.EventChannel
import android.os.Handler
import android.os.Looper

import android.util.Log

class BluetoothDeviceScanningStreamHandler(): EventChannel.StreamHandler {
    val TAG = "BluetoothDeviceScanningStreamHandler"

    private var _btScannedDevicesEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "stream Handler - onListen")

        _btScannedDevicesEventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "stream handler - onCancel")
        _btScannedDevicesEventSink = null;
    }


    fun updateBluetoothScanList(devices: List<BluetoothDeviceEntity>) {
        Log.d(TAG, "Kotlin -> In updateBluetoothScanList")
        println(devices)

        var _bluetoothDevicesList:  MutableList<Map<String, String?>> = mutableListOf()

        for (x in (0..devices.size-1)) {
            val tempDevice: Map<String, String?> = mapOf(
                "name" to devices[x].name,
                "address" to devices[x].address,
            )
            _bluetoothDevicesList.add(tempDevice)
        }

        println(_bluetoothDevicesList)

        val handler = Handler(Looper.getMainLooper())

        handler.post {
            _btScannedDevicesEventSink?.success(_bluetoothDevicesList.toString())
        }

    }
}