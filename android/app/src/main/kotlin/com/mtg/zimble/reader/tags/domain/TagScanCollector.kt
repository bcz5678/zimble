package com.mtg.zimble.reader.tags.domain

import com.mtg.zimble.reader.tags.data.TagScanData

//import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

import android.util.Log

class TagScanCollector(
    private val tagDataScanStreamHandlerInstance: TagDataScanStreamHandler,
    private val tagDataScanState: StateFlow<TagScanData>
) {
    private val TAG = "TagScanCollector"

    init{
        // Start Collector to listen for StateFLow changes to devices
        // REVISIT LIFECYCLE SCOPE HERE FOR SAFETY AND MEMORY LEAK
        CoroutineScope(Dispatchers.IO).launch {
            tagDataScanState.collect { tagScanDataItem: TagScanData ->
                if (tagScanDataItem.epc != "INITIAL") {
                    sendDataToStreamHandler(tagDataScanStreamHandlerInstance, tagScanDataItem)
                } else {
                    doWhenNothing()
                }
            }
        }
    }

    private fun sendDataToStreamHandler(
        tagDataScanStreamHandlerInstance: TagDataScanStreamHandler,
        tagScanDataItem: TagScanData,
    ) {
        tagDataScanStreamHandlerInstance.updateTagDataScanStream(tagScanDataItem)
    }

    private fun doWhenNothing() {
        Log.d(TAG, "in doWhenNothing")
        return
    }

}