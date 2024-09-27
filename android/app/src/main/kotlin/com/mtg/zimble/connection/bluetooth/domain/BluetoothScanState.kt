package com.example.untitled.connection.bluetooth.domain

//import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers


import android.util.Log



class bluetoothScanningCollector(
    //private val coroutineScope: CoroutineScope,
    private val btStreamHandlerInstance: BluetoothDeviceScanningStreamHandler,
    private val scannedDevicesState: StateFlow<List<BluetoothDeviceEntity>>
) {

    private val TAG = "BluetoothScanState"

    init {
        //Testing pass by reference
        //println("btStreamHandlerInstance Hash Code - ${btStreamHandlerInstance.hashCode()}")
        //println("btStreamHandlerInstance Reference Code - ${Integer.toHexString(System.identityHashCode(btStreamHandlerInstance))}")

        //Start Collector to listen for StateFLow changes to devices
        // REVISIT LIFECYCLE SCOPE HERE FOR SAFETY ADN MEMORY LEAK
        CoroutineScope(Dispatchers.IO).launch {
            scannedDevicesState.collect {
                devices -> if(devices.isNotEmpty()) sendDataToStreamHandler(btStreamHandlerInstance, devices) else doWhenNothing()
            }
        }
    }

    // Sending Scan Updates to the Stream Handler
    private fun sendDataToStreamHandler(btStreamHandlerInstance: BluetoothDeviceScanningStreamHandler, devicesList: List<BluetoothDeviceEntity>) {
        Log.d(TAG, "Kotlin -> In sendDataToStreamHandler")
        Log.d(TAG, "${devicesList}")

        btStreamHandlerInstance.updateBluetoothScanList(devicesList)
    }


    private fun doWhenNothing() {
        return
    }
}
