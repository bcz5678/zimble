package com.mtg.zimble.channels.domain


import com.mtg.zimble.reader.main.data.AndroidReaderController


import android.content.Context
import android.util.Log
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceScanningStreamHandler

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class ReaderMainChannels(context: Context) {
    //Debug Tag
    val TAG = "ReaderDeviceChannels"

    ///Create Stream Channel Names to match FLlutter
    private val READER_MAIN_METHOD = "mtg_rfid_method/reader/reader_main_method"
    private val READER_MAIN_STREAM = "mtg_rfid_event/reader/reader_main_method"

    ///Create the Channels to use to transfer data
    private lateinit var _readerMainMethodChannel : MethodChannel
    public lateinit var readerMainStreamChannel : EventChannel

    ///Creates a Scanning Stream Handler instance to pass to the controller and collector
    var btStreamHandlerInstance = BluetoothDeviceScanningStreamHandler()

    ///Instantiate reader controllers
    private val _androidReaderController = AndroidReaderController()

    ///Handler for all MethodChannel messages
    fun initializeReaderMainChannels(messenger: BinaryMessenger) {
        Log.d(TAG, "initializing ReaderMain AndroidChannels")

        //READER_MAIN Method Channel for calls from Features->Reader
        _readerMainMethodChannel = MethodChannel(messenger, READER_MAIN_METHOD)
        Log.d(TAG, "Reaeder_Main Methodchannels initialized ")

        ///READER_MAIN Stream Channel
        readerMainStreamChannel = EventChannel(messenger, READER_MAIN_STREAM)

        ///Assign StreamHandler
        readerMainStreamChannel.setStreamHandler(btStreamHandlerInstance)

        Log.d(TAG, "BT Streamchannels initialized ")

        ///MethodCalls
        _readerMainMethodChannel.setMethodCallHandler { call, result ->
            when{
                /// Get Previously Paired BluetoothDevices from Device
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type: List<BluetoothModel>>
                call.method.equals("testReaderMain") -> {
                    Log.d(TAG, "in call method - testReaderMain")

                    result.success("TestReaderMainSuccess")
                }
            }
        }
    }

    fun teardownChannels() {

    }
}