package com.mtg.zimble.reader.tags.domain

//import android.content.Context
import io.flutter.plugin.common.EventChannel
import android.os.Handler
import android.os.Looper

import com.google.gson.Gson
import com.google.gson.GsonBuilder



import android.util.Log

class TagScanStreamHandler(): EventChannel.StreamHandler {
    val TAG = "TagScanStreamHandler"

    private var _tagScanEventSink: EventChannel.EventSink? = null

    var gson : Gson = GsonBuilder().serializeNulls().create();

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        _tagScanEventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        _tagScanEventSink = null;
    }


    fun updateTagScanList(tagsList: List<TagData>) {
        var _tagScanList:  MutableList<String?> = mutableListOf()

        for (x in (0..devices.size-1)) {
            val tempDevice: Map<String, String?> = mapOf(
                "name" to devices[x].name,
                "address" to devices[x].address,
            )
            _bluetoothDevicesList.add(gson.toJson(tempDevice))
        }

        val handler = Handler(Looper.getMainLooper())

        handler.post {
            _btScannedDevicesEventSink?.success(_bluetoothDevicesList)
        }

    }
}