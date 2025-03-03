package com.mtg.zimble.reader.tags.domain

import android.util.Log
import io.flutter.plugin.common.EventChannel
import com.mtg.zimble.reader.tags.data.TagData



class TagDataScanStreamHandler(
  ) : EventChannel.StreamHandler {
    val TAG = "TagDataScanStreamHandler"
    private var tagDataScanEventSink: EventChannel.EventSink? = null

    // Overrides EventChannel onListen, from the flutter listen side
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen - TagDatScanStreamHandler")
        tagDataScanEventSink = events
    }

    //Overrides EventChannel onCancel to stop listening  on flutter stream .cancel()
    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        tagDataScanEventSink = null
    }

    fun updateTagDataScanStream(tagDataList : List<TagData>) {
        var _tagDataScanList:  MutableList<String?> = mutableListOf()

        for (x in (0..tagDataList.size - 1)) {
            _tagDataScanList.add(tagDataList[x].toJson())
        }

        tagDataScanEventSink?.success(_tagDataScanList)
    }


}