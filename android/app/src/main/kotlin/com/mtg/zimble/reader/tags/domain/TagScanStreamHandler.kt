package com.mtg.zimble.reader.tags.domain

import android.util.Log
import io.flutter.plugin.common.EventChannel

class TagScanStreamHandler: EventChannel.StreamHandler {
    val TAG = "TagScanStreamHandler"
    private var tagScanEventSink: EventChannel.EventSink? = null

    // Overrides EventChannel onListen, from the flutter listen side
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen -")
        tagScanEventSink = events
    }

    //Overrides EventChannel onCancel to stop listening  on flutter stream .cancel()
    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        tagScanEventSink = null
    }
}