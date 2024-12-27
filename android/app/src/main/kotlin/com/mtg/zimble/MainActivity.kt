package com.mtg.zimble

import com.mtg.zimble.channels.domain.BluetoothDeviceChannels
import com.mtg.zimble.channels.domain.ReaderMainChannels
import com.mtg.zimble.channels.domain.SensorChannels

import com.mtg.zimble.reader.main.domain.ReaderConnectionState

import android.content.Context
import android.os.Bundle
import android.util.Log

import com.uk.tsl.rfid.asciiprotocol.AsciiCommander
import com.uk.tsl.rfid.asciiprotocol.DeviceProperties
import com.uk.tsl.rfid.asciiprotocol.commands.BluetoothCommand
import com.uk.tsl.rfid.asciiprotocol.device.ReaderManager
import com.uk.tsl.rfid.asciiprotocol.enumerations.TriState
import com.uk.tsl.rfid.asciiprotocol.responders.LoggerResponder

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger


class MainActivity: FlutterActivity() {
    // Initial creation point for SDK

    val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "App started")
    }

    // Initial Flutter entry point
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initialConfig();
    }


    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }

    private fun initialConfig() {
        ///Initial App Config

        ///Make Sure Bluetooth enabled
        BluetoothCommand().setBluetoothEnabled(TriState.YES)

        ///Initialize Main AsciCommander shared instance
        AsciiCommander.createSharedInstance(applicationContext)
        val commander = AsciiCommander.sharedInstance()

        // Ensure that all existing responders are removed
        commander.clearResponders()

        Log.d(TAG, "Post AsciSharedInstance - ${commander}");
        Log.d(TAG, "ConnectedReader - ${commander.getConnectedDeviceName()}")
        commander.addResponder(LoggerResponder())

        //Create the ReaderManager shared instance
        ReaderManager.create(applicationContext)
        Log.d(TAG, "ReaderManagerSharedInstance - ${ReaderManager.sharedInstance()}")
        ReaderManager.sharedInstance().initialiseList()
        Log.d(TAG, "ReaderList - ${ReaderManager.sharedInstance().getReaderList().list()}")

        ReaderConnectionState()

        val rfidDeviceManager = DeviceProperties()
        Log.d(TAG, "rfidDeviceManager - ${rfidDeviceManager}")
        Log.d(TAG, "reader isConnected - ${commander.isConnected()}")

        //SetUp method and Event Channels
        setupMainChannels(applicationContext, flutterEngine!!.dartExecutor.binaryMessenger)
    }

    private fun setupMainChannels(context: Context, messenger: BinaryMessenger) {

        val bluetoothDeviceChannels = BluetoothDeviceChannels(context)
        bluetoothDeviceChannels.initializeBluetoothDeviceChannels(messenger)

        val readerMainChannels = ReaderMainChannels(context)
        readerMainChannels.initializeReaderMainChannels(messenger)

        //val sensorChannels = SensorChannels(context)
        //sensorChannels.initializeSensorChannels(messenger)

        //set Event StreamHandler
        //rfidEventChannel!!.setStreamHandler(MyStreamHandler(context))
    }


    private fun teardownChannels() {

        //Call Imported Class TearDowns
        //ReaderClass().teardownReaderHandlers()

    }
}