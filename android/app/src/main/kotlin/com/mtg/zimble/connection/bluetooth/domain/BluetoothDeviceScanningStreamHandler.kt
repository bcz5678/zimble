package com.mtg.zimble.connection.bluetooth.domain

//import android.content.Context
import io.flutter.plugin.common.EventChannel
import android.os.Handler
import android.os.Looper

import com.google.gson.Gson
import com.google.gson.GsonBuilder



import android.util.Log

class BluetoothDeviceScanningStreamHandler(): EventChannel.StreamHandler {
    val TAG = "BluetoothDeviceScanningStreamHandler"

    private var _btScannedDevicesEventSink: EventChannel.EventSink? = null

    var gson : Gson = GsonBuilder().serializeNulls().create();

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        _btScannedDevicesEventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        _btScannedDevicesEventSink = null;
    }


    fun updateBluetoothScanList(devices: List<BluetoothDeviceEntity>) {
        println(devices)

        var _bluetoothDevicesList:  MutableList<String?> = mutableListOf()

        for (x in (0..devices.size-1)) {
            val tempDevice: Map<String, String?> = mapOf(
                "name" to devices[x].name,
                "address" to devices[x].address,
            )
            _bluetoothDevicesList.add(gson.toJson(tempDevice))
        }

        println(_bluetoothDevicesList)

        val handler = Handler(Looper.getMainLooper())

        handler.post {
            _btScannedDevicesEventSink?.success(_bluetoothDevicesList)
        }

    }
}