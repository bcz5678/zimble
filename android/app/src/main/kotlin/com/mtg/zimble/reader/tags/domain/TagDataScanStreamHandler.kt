package com.mtg.zimble.reader.tags.domain

import android.util.Log
import io.flutter.plugin.common.EventChannel
import com.mtg.zimble.reader.tags.data.TagData

class TagDataScanStreamHandler: EventChannel.StreamHandlerv(
    private val tagDataScanList: StateFlow<List<TagData>>
) {
    val TAG = "TagDataScanStreamHandler"
    private var tagDataScanEventSink: EventChannel.EventSink? = null

    // Overrides EventChannel onListen, from the flutter listen side
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen - TagDatScanStreamHandler")
        tagDataScanEventSink = events

        // Start Collector to listen for StateFLow changes to devices
        // REVISIT LIFECYCLE SCOPE HERE FOR SAFETY ADN MEMORY LEAK
        CoroutineScope(Dispatchers.IO).launch {
            tagDataScanList.collect {
                    tagDatas -> if(tagDatas.isNotEmpty()) updateTagDataScanStream(tagDatas) else doWhenNothing()
            }
        }

    }

    //Overrides EventChannel onCancel to stop listening  on flutter stream .cancel()
    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        tagDataScanEventSink = null
    }

    /*
    fun listenForTranspondersStream(transponders: List<TransponderData>) {
        var _scannedTrandposersList: MutableList<TransponderData> = mutableListOf()

        for (x in (0..transponders.size - 1)) {
            val tempDevice: Map<String, String?> = mapOf(
                "name" to devices[x].name,
                "address" to devices[x].address,
            )
            _bluetoothDevicesList.add(gson.toJson(tempDevice))
        }
    }
     */

    privae updateTagDataScanStream(tagDataList : List<TagData>) {
        var _tagDataScanList:  MutableList<String?> = mutableListOf()

        for (x in (0..tagDataList.size - 1)) {
            _tagDataScanList.add(tagDataList[x].toJson())
        }

        tagDataScanEventSink?.success(_tagDataScanList)
    }



    private fun doWhenNothing() {
        return
    }
}