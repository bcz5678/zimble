package com.mtg.zimble.reader.tags.domain

import android.util.Log
import io.flutter.plugin.common.EventChannel
import com.mtg.zimble.reader.tags.data.TagScanData
import android.os.Handler
import android.os.Looper


class TagDataScanStreamHandler(
  ) : EventChannel.StreamHandler {
    val TAG = "TagDataScanStreamHandler"
    private var _tagDataScanEventSink: EventChannel.EventSink? = null

    // Overrides EventChannel onListen, from the flutter listen side
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen - TagDataScanStreamHandler")
        _tagDataScanEventSink = events
    }

    //Overrides EventChannel onCancel to stop listening  on flutter stream .cancel()
    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel- TagDataScanStreamHandler")
        _tagDataScanEventSink = null
    }

    fun updateTagDataScanStream(tagScanDataItem : TagScanData) {

        //Use Handler and Looper to Return to the MainUI thread to send down the line
        val handler = Handler(Looper.getMainLooper())

        handler.post {
            _tagDataScanEventSink?.success(tagScanDataItem.toJson())
        }
    }
}