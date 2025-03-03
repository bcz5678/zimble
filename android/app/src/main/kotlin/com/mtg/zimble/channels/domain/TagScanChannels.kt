package com.mtg.zimble.channels.domain

import com.mtg.zimble.reader.tags.data.AndroidTagController
import com.mtg.zimble.reader.tags.domain.TagDataScanStreamHandler

import android.content.Context
import android.util.Log
import android.view.KeyEvent.DispatcherState
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel



import com.uk.tsl.rfid.asciiprotocol.responders.LoggerResponder;
import kotlinx.coroutines.CoroutineScope

class TagScanChannels(context: Context, messenger: BinaryMessenger) {
    val TAG = "TagScanChannels"

    ///Create Stream Channel Names to match Flutter

    private val METHOD_TAG_SCAN = "mtg_rfid_method/reader/tag_scan_method"
    private val STREAM_TAG_SCAN = "mtg_rfid_event/reader/tag_scan_stream"

    ///Create the Channels to use to transfer data
    private lateinit var _tagScanMethodChannel : MethodChannel
    lateinit var tagScanStreamChannel : EventChannel

    private var _androidTagController : AndroidTagController = AndroidTagController()

    init {
        initializeTagScanChannels(context, messenger)
    }

    ///Creates a Sensor Stream Handler instances to pass to the controller and collector
    var tagDataScanStreamHandler = TagDataScanStreamHandler()

    fun initializeTagScanChannels(context:Context, messenger: BinaryMessenger) {
        Log.d(TAG, "initializing TagScan Android Channels")

        //TagScan MethodChannel SetUp
        _tagScanMethodChannel = MethodChannel(messenger, METHOD_TAG_SCAN)
        Log.d(TAG, "TagScan MethodChannel initialized ")

        //TagScan EventChannel  setup for stream
        tagScanStreamChannel = EventChannel(messenger, STREAM_TAG_SCAN)

        //Define TagScan Method Calls
        _tagScanMethodChannel.setMethodCallHandler { call, result ->
            when {
                call.method.equals("startTagScanStream") -> {
                    try {
                        Log.d(TAG, "in startTagScan")
                        if(AndroidTagController().isConnected() == true) {
                            Log.d(TAG, "AndroidTagController is connected")

                            //Assign StreamHandler for tagScan
                            tagScanStreamChannel.setStreamHandler(tagDataScanStreamHandler)

                            if (!_androidTagController.isEnabled()) {
                                _androidTagController.getCommander().clearResponders()
                                _androidTagController.getCommander().addResponder(LoggerResponder())
                                _androidTagController.getCommander().addSynchronousResponder()
                                _androidTagController.setEnabled(true)

                            }

                            if(_androidTagController.isEnabled()== true) {
                                _androidTagController.scanStart()
                            }

                            result.success("tagScanStreamStartSuccess")
                        } else {
                            Log.d(TAG, "AndroidTagController is not connected")
                            result.error("tagScanStartError", "No Reader Connected", null)
                        }
                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - startTagScan - error")
                        result.error("tagScanStartError", "There was a problem starting the TagScan", null)
                    }
                }

                call.method.equals("stopTagScanStream") -> {
                    try {
                        Log.d(TAG, "In stopTagScanStream")
                        _androidTagController.scanStop()

                        result.success("tagScanStreamStopSuccess")
                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - stopTagScan - error")
                        result.error("tagScanStopError", "There was a problem stopping the TagScan", null)
                    }
                }
            }
        }
    }
}