package com.mtg.zimble.reader.trigger.domain

//import android.content.Context
import io.flutter.plugin.common.EventChannel
import android.os.Handler
import android.os.Looper

import android.util.Log

class TriggerStreamHandler(): EventChannel.StreamHandler {
    val TAG = "TriggerStreamHandler"

    private var _triggerEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "Trigger Stream Handler - onListen")

        _triggerEventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "Trigger Stream Handler - onCancel")
        _triggerEventSink = null;
    }


    /*
    fun updateTriggerStream(devices: List<BluetoothDeviceEntity>) {
        Log.d(TAG, "Kotlin -> In updateTriggerStream")
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
     */
}