package com.mtg.zimble.channels.domain

//Controllers
import com.mtg.zimble.connection.bluetooth.data.AndroidBluetoothController
import com.mtg.zimble.reader.main.data.AndroidReaderController
import com.mtg.zimble.reader.trigger.data.AndroidTriggerController

//Entities

import android.content.Context
import android.util.Log
import com.mtg.zimble.channels.data.MethodMapData
import com.mtg.zimble.connection.bluetooth.domain.BluetoothConnectionHandler
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceEntity
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceScanningStreamHandler

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.async


class BluetoothDeviceChannels(context: Context, messenger: BinaryMessenger) {
    val TAG = "BluetoothDeviceChannels"
    
    ///Create Stream Channel Names to match Flutter
    private val BT_DEVICES_METHOD = "mtg_rfid_method/device/bt_devices"
    private val BT_DEVICES_STREAM = "mtg_rfid_event/device/bt_stream"

    ///Create the Channels to use to transfer data
    private lateinit var _bluetoothDeviceMethodChannel : MethodChannel
    public lateinit var bluetoothDeviceStreamChannel : EventChannel

    ///Creates a Scanning Stream Handler instance to pass to the controller and collector
    var bluetoothStreamHandler = BluetoothDeviceScanningStreamHandler()

    ///Instantiate controllers
    private val _androidBluetoothController = AndroidBluetoothController(context)
    private val _androidReaderController = AndroidReaderController()
    private val _androidTriggerController = AndroidTriggerController()

    ///Instantiate connectionHandler
    private val _bluetoothConnectionHandler = BluetoothConnectionHandler(bluetoothController = _androidBluetoothController, context = context)

    init{
        initializeBluetoothDeviceChannels(context, messenger)
    }

    ///Handler for all MethodChannel messages
    fun initializeBluetoothDeviceChannels(context: Context, messenger: BinaryMessenger) {
        Log.d(TAG, "initializing BT Android Channels")

        //Bluetooth Method Channel for calls from Features->Reader
        _bluetoothDeviceMethodChannel = MethodChannel(messenger, BT_DEVICES_METHOD)
        Log.d(TAG, "BT Methodchannels initialized ")

        //Bluetooth Stream Channel for scanned device streams from Features->Reader
        bluetoothDeviceStreamChannel = EventChannel(messenger, BT_DEVICES_STREAM)

        Log.d(TAG, "BT Streamchannels initialized ")

        ///MethodCalls
        _bluetoothDeviceMethodChannel.setMethodCallHandler { call, result ->
            when{
                /// Get Previously Paired BluetoothDevices from Device
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type: List<BluetoothModel>>
                call.method.equals("getPairedBluetoothDevices") -> {
                    Log.d(TAG, "in call method - getPairedBluetoothDevices")
                    var _pairedBluetoothDevices: MutableList<Map<String, Any?>> = _androidBluetoothController.getPairedDevices()
                    Log.d(TAG, "in call method - getPairedBluetoothDevices - deviceList - ${_pairedBluetoothDevices}")
                    result.success(_pairedBluetoothDevices)
                }
                /// Start discovery and get a stream of discovered BluetoothDevices
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type: String - "started"  (Also starts btStreamHandler)
                call.method.equals("startScanningBluetoothDevices") -> {
                    try {
                        Log.d(TAG, "in call method - startScanningBluetoothDevices")

                        ///Assign StreamHandler for scanned devices
                        bluetoothDeviceStreamChannel.setStreamHandler(bluetoothStreamHandler)
                        _androidBluetoothController.startDiscovery(bluetoothStreamHandler)

                        result.success("started")
                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - startScanningBluetoothDevices - ${e.message.toString()}")
                        result.error("startScanningBluetoothDevicesError", "There was a problem starting the BLuetoothScan Stream", null)
                    }
                }
                /// Stop discovery of BluetoothDevices
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type: String - "stopped"
                call.method.equals("stopScanningBluetoothDevices") -> {
                    try {
                        _androidBluetoothController.stopDiscovery()
                        result.success("stopped")
                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - stopScanningBluetoothDevices - ${e.message.toString()}")
                        result.error("staopScanningBluetoothDevicesError", "There was a problem stopping the BLuetoothScan Stream - ${e.message.toString()}", null)
                    }
                }
                /// Connect to a specific BluetoothDevice
                /// Call Type: InvokeMapMethod
                /// Data Message Type: MessageData  BluetoothDeviceModel
                /// Return Type: Map<String, dynamic?>
                call.method.equals("connectToBluetoothDevice") -> {
                    Log.d(TAG, "in call method - connectToBluetoothDevice")

                    //Parse messageData from MethodCall
                    var messageData = call.argument<Map<String, Any?>>("messageData")!!
                    var bluetoothDeviceToConnect: BluetoothDeviceEntity = BluetoothDeviceEntity.fromJson(messageData)

                    Log.d(TAG, "bluetoothDeviceToConnect - ${bluetoothDeviceToConnect}")

                    // Instantiate connectionResult
                    var connectionResult: Boolean = false;

                    // Start async call to connect and await connection details
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            // Get currently paired bluetooth devices
                            var _pairedDevices:  MutableList<Map<String, Any?>> = _androidBluetoothController.getPairedDevices();

                            Log.d(TAG, "Starting connection")

                            // If device from MethodCall is in pairedDevices, start ReaderSDK connection to device
                            if (_pairedDevices.any {it["address"] == bluetoothDeviceToConnect.address}) {
                                connectionResult = async {
                                    Log.d(TAG, "connecting paired device")
                                    _androidReaderController.connectToSDKReader(
                                        bluetoothDeviceToConnect
                                    )
                                }.await()
                            } else {

                                // If device forom MethodCall is NOT in pairedDevices, start Native connection/pair to device
                                var nativeConnectionResult: Boolean = async {
                                    Log.d(TAG, "connecting scanned device through native")
                                    _androidBluetoothController.connectToDevice(bluetoothDeviceToConnect)
                                }.await()

                                //If native connection/pair success, disconnect native
                                if (nativeConnectionResult == true) {
                                    var nativeDisconnectionResult: Boolean = async {
                                        Log.d(TAG, "disconnecting BT device from native")
                                        _androidBluetoothController.disconnectFromDevice(
                                            bluetoothDeviceToConnect
                                        )
                                    }.await()

                                    //if native connection disconnected, start ReaderSDK connection to device
                                    if (nativeDisconnectionResult == false) {
                                        connectionResult = async {
                                            Log.d(TAG, "connecting scanned device through SDK")
                                            _androidReaderController.connectToSDKReader(
                                                bluetoothDeviceToConnect
                                            )
                                        }.await()
                                    }
                                }
                            }

                            Log.d(TAG, "Reader Connection Result - ${connectionResult}")

                            // If Reader SDK connection success, get asic deviceProperties and send full Reader Details back to Channel
                            if (connectionResult == true) {
                                Log.d(TAG, "Connected Reader - ${_androidReaderController.getConnectedReaderName()}")

                                bluetoothDeviceToConnect.connectionStatus = true
                                bluetoothDeviceToConnect.readerDetails = _androidReaderController.getReaderDeviceProperties()
                                //Log.d(TAG, bluetoothDeviceToConnect.readerDetails!!.asMap().toString())

                                bluetoothDeviceToConnect.triggerSettings = _androidTriggerController.getReaderTriggerSettingsProperties()
                                //Log.d(TAG, bluetoothDeviceToConnect.triggerSettings!!.asMap().toString())

                                //Log.d(TAG, bluetoothDeviceToConnect.readerDetails!!::class.simpleName.toString())
                                //Log.d(TAG, bluetoothDeviceToConnect.triggerSettings!!::class.simpleName.toString())
                                //Log.d(TAG, bluetoothDeviceToConnect.toMap().toString())

                                Log.d(TAG, MethodMapData.create(bluetoothDeviceToConnect.toMessageMap()).toString())

                                result.success(MethodMapData.create(bluetoothDeviceToConnect.toMessageMap()))
                            } else {
                                //SDK Connection Error Return
                                result.error("connectionError", "There was a problem connecting to this reader", null)
                            }
                        } catch  (e: Exception) {
                            //SDK Connection Error Return
                            Log.d(TAG, "Error - ${e.message.toString()}")
                            result.error("connectionError", "There was a problem connecting to this reader", null)
                        }
                    }
                }
                /// Disconnect from a specific BluetoothDevice
                /// Call Type: InvokeMapMethod
                /// Data Message Type: MessageData - BluetoothDeviceModel
                /// Return Type: Map<String, dynamic?>
                call.method.contains("disconnectFromBluetoothDevice") -> {
                    Log.d(TAG, "in call method - disconnectFromBluetoothDevice")

                    //Parse messageData from MethodCall
                    var messageData = call.argument<Map<String, Any?>>("messageData")!!
                    var bluetoothDeviceToDisconnect: BluetoothDeviceEntity = BluetoothDeviceEntity.fromJson(messageData)

                    Log.d(TAG, "bluetoothDeviceToDisconnect - ${bluetoothDeviceToDisconnect}")

                    //Start async call to connect and await connection details
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            //Disconnect Reader SDK connection
                            var connectionSDKResult: Boolean = async {
                                Log.d(TAG, "Starting disconnection")
                                _androidReaderController.disconnectFromReader(bluetoothDeviceToDisconnect)
                            }.await()

                            Log.d(TAG, "Reader SDK Disconnection Result - ${connectionSDKResult}")

                            //Disconnect Native connection
                            var connectionNativeResult: Boolean = async {
                                Log.d(TAG, "Starting disconnection")
                                _androidBluetoothController.disconnectFromDevice(bluetoothDeviceToDisconnect)
                            }.await()

                            Log.d(TAG, "Reader Native DisConnection Result - ${connectionNativeResult}")

                            // If SDK and Native disconnect success, return BluetoothDeviceModel disconnected status
                            if (connectionSDKResult == true && connectionNativeResult == true) {
                                Log.d(TAG, "In connectionSDKResult and connectionNativeResult success")

                                bluetoothDeviceToDisconnect.connectionStatus = false
                                bluetoothDeviceToDisconnect.readerDetails = null
                                bluetoothDeviceToDisconnect.triggerSettings = null
                                result.success(MethodMapData.create(bluetoothDeviceToDisconnect.toMessageMap()))
                            } else {
                                //Error Return
                                result.error("connectionError", "There was a problem disconnecting from this reader", null)
                            }
                        } catch  (e: Exception) {
                            //Error Return
                            Log.d(TAG, "Error - ${e.message.toString()}")
                            result.error("connectionError", "There was a problem disconnecting from this reader", null)
                        }
                    }
                }
            }
        }
    }
}