package com.mtg.zimble.connection.bluetooth.domain

//import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers


class BluetoothScanCollector(
    //private val coroutineScope: CoroutineScope,
    private val btStreamHandlerInstance: BluetoothDeviceScanningStreamHandler,
    private val scannedDevicesState: StateFlow<List<BluetoothDeviceEntity>>
) {
    private val TAG = "BluetoothScanCollector"

    init {
        // Start Collector to listen for StateFLow changes to devices
        // REVISIT LIFECYCLE SCOPE HERE FOR SAFETY ADN MEMORY LEAK
        CoroutineScope(Dispatchers.IO).launch {
            scannedDevicesState.collect {
                devices -> if(devices.isNotEmpty()) sendDataToStreamHandler(btStreamHandlerInstance, devices) else doWhenNothing()
            }
        }
    }

    // Sending Scan Updates to the Stream Handler
    private fun sendDataToStreamHandler(
        btStreamHandlerInstance: BluetoothDeviceScanningStreamHandler,
        devicesList: List<BluetoothDeviceEntity>
    ) {
        btStreamHandlerInstance.updateBluetoothScanList(devicesList)
    }


    private fun doWhenNothing() {
        return
    }
}
