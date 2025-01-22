package com.mtg.zimble.channels.domain

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.util.Log
import com.mtg.zimble.reader.tags.domain.TagScanStreamHandler

class TagScanChannels(context: Context, messenger: BinaryMessenger) {
    val TAG = "TagScanChannels"

    ///Create Stream Channel Names to match Flutter

    private val METHOD_TAG_SCAN = "mtg_rfid_method/reader/tag_scan_method"
    private val STREAM_TAG_SCAN = "mtg_rfid_event/reader/tag_scan_stream"

    ///Create the Channels to use to transfer data
    private lateinit var _tagScanMethodChannel : MethodChannel
    lateinit var tagScanStreamChannel : EventChannel

    init {
        initializeTagScanChannels(context, messenger)
    }

    ///Creates a Sensor Stream Handler instances to pass to the controller and collector
    var tagScanStreamHandler = TagScanStreamHandler()

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
                call.method.equals("startTagScan") -> {
                    try {
                        Log.d(TAG, "in startTagScan")

                        //Assign StreamHandler for tagScan
                        tagScanStreamChannel.setStreamHandler(tagScanStreamHandler)

                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - startTagScan - error")
                        result.error("tagScanStartError", "There was a problem starting the TagScan", null)
                    }
                }

                call.method.equals("stopTagScan") -> {
                    try {

                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - stopSensors - error")
                        result.error("tagScanStopError", "There was a problem stopping the TagScan", null)
                    }
                }
            }
        }
    }
}