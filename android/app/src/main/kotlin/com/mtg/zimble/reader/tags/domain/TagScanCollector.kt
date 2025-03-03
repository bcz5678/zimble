package com.mtg.zimble.reader.tags.domain

import com.mtg.zimble.reader.tags.data.TagData

//import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

class TagScanCollector(
    private val tagDataScanStreamHandlerInstance: TagDataScanStreamHandler,
    private val tagDataScanState: StateFlow<List<TagData>>
) {
    private val TAG = "TagScanCollector"

    init{
        // Start Collector to listen for StateFLow changes to devices
        // REVISIT LIFECYCLE SCOPE HERE FOR SAFETY AND MEMORY LEAK
        CoroutineScope(Dispatchers.IO).launch {
            tagDataScanState.collect {
                    tagDatas -> if(tagDatas.isNotEmpty()) sendDataToStreamHandler(tagDataScanStreamHandlerInstance, tagDatas) else doWhenNothing()
            }
        }
    }

    private fun sendDataToStreamHandler(
        tagDataScanStreamHandlerInstance: TagDataScanStreamHandler,
        tagDataList: List<TagData>,
    ) {
        tagDataScanStreamHandlerInstance.updateTagDataScanStream(tagDataList)
    }

    private fun doWhenNothing() {
        return
    }

}