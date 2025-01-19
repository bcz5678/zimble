package com.mtg.zimble.connection.bluetooth.data

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.content.Context.RECEIVER_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.util.Log
import com.mtg.zimble.connection.bluetooth.domain.BluetoothController
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceEntity
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceScanningStreamHandler
import com.mtg.zimble.connection.bluetooth.domain.ConnectionResult
import com.mtg.zimble.connection.bluetooth.domain.bluetoothScanningCollector
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import java.io.IOException
import java.util.UUID


//import com.mtg.zimble.bluetooth.data.BluetoothEnableActivity

@SuppressLint("MissingPermission")
class  AndroidBluetoothController(
    private val context: Context,
): BluetoothController {

    var TAG = "AndroidBluetoothController"

    //Setting up the Bluetooth manager and adapter for use
    private val bluetoothManager by lazy {
        context.getSystemService(BluetoothManager::class.java)
    }
    private val bluetoothAdapter by lazy {
        bluetoothManager?.adapter
    }

    // StateFlow for scanned devices
    private var _scannedDevices = MutableStateFlow<List<BluetoothDeviceEntity>>(emptyList())
    override val scannedDevices: StateFlow<List<BluetoothDeviceEntity>>
        get() = _scannedDevices.asStateFlow()

    //StateFLow for paired devices
    private val _pairedDevices = MutableStateFlow<List<BluetoothDeviceEntity>>(emptyList())
    override val pairedDevices: StateFlow<List<BluetoothDeviceEntity>>
        get() = _pairedDevices.asStateFlow()


    private val _isConnected = MutableStateFlow<Boolean>(false)
    override val isConnected: StateFlow<Boolean>
        get() = _isConnected.asStateFlow()


    private val  _errors = MutableSharedFlow<String>()
    override val errors: SharedFlow<String>
        get() = _errors.asSharedFlow()


    private var currentServerSocket: BluetoothServerSocket? = null
    private var currentClientSocket: BluetoothSocket? = null


    //Create Broadcast Receiver to update scanned devices
    private val foundDeviceReceiver = FoundDeviceReceiver{
        device -> _scannedDevices.update {
            devices -> val newDevice = device.toBluetoothDeviceEntity()
            if(newDevice in  devices) devices else devices + newDevice
        }
    }

    //Create BluetoothState Receiver to listen to connection status changes
    private val bluetoothStateReceiver = BluetoothStateReceiver{ isConnected, bluetoothDevice ->
        if(bluetoothAdapter?.bondedDevices?.contains(bluetoothDevice) == true) {
            _isConnected.update { isConnected }
        } else {
            CoroutineScope(Dispatchers.IO).launch {
                _errors.emit("Can't connect to a non-paired device.")
            }
        }
    }

    init {
        updatePairedDevices()
        if (!bluetoothStateReceiver.isRegistered) {
            bluetoothStateReceiver.registerAsReceiver(context)
        }
    }

    //Start scan for available Bluetooth devices
    override fun startDiscovery(streamHandlerInstanceTest: BluetoothDeviceScanningStreamHandler){
        Log.d(TAG, "in startDiscovery")

        if (!bluetoothStateReceiver.isRegistered) {
            bluetoothStateReceiver.registerAsReceiver(context)
        }

        //stop previous discovery that may still be in background
        if(bluetoothAdapter?.isDiscovering() == true) {
            bluetoothAdapter?.cancelDiscovery()
            release()
        }


        //Check we have manifest permissions for scanning
        if(!hasPermission(Manifest.permission.BLUETOOTH_SCAN)) {
            return
        }

        //Initialize the Stateflow Collector to receive devices state changes
        bluetoothScanningCollector(streamHandlerInstanceTest, scannedDevices)

        Log.d(TAG, "ABTC - startDiscovery")

        if (!foundDeviceReceiver.isRegistered) {
            foundDeviceReceiver.registerAsReceiver(context)
        }

        // update paired devices before discovery
        updatePairedDevices()

        // resets the scanned devices list to 0 to start a new scan
        _scannedDevices.update {
                devices -> ArrayList<BluetoothDeviceEntity>(0)
        }

        //start new scan
        bluetoothAdapter?.startDiscovery()
    }

    //Stop scan for available Bluetooth devices
    override fun stopDiscovery() {
        if(!hasPermission(Manifest.permission.BLUETOOTH_SCAN)) {
            return
        }

        Log.d(TAG, "ABTC - stopDiscovery")

        var cancelDiscoveryResult = bluetoothAdapter?.cancelDiscovery()

        release()
    }

    override fun connectToDevice(device: BluetoothDeviceEntity): Boolean {
        Log.d(TAG, "In ABTC - connectToDevice")

            var connectionStatus: Boolean  = false;

            if(!hasPermission((Manifest.permission.BLUETOOTH_CONNECT))) {
                throw SecurityException("No BLUETOOTH_CONNECT permission")
            }

            Log.d(TAG, "In ABTC - connectToDevice FLOW")

            if (bluetoothAdapter?.isDiscovering() == true) {
                stopDiscovery()
            }

            currentClientSocket = bluetoothAdapter
                ?.getRemoteDevice(device.address)
                ?.createRfcommSocketToServiceRecord(
                    UUID.fromString(SERVICE_UUID)
                )
            Log.d(TAG, "currentClientSocket - ${currentClientSocket.toString()}")

            currentClientSocket?.let{ socket ->
                try {
                    socket.connect()
                    //emit(ConnectionResult.ConnectionEstablished(device.address))
                    Log.d(TAG, "Connection Established")
                    connectionStatus = true
                } catch (e: IOException) {
                    socket.close()
                    currentClientSocket = null
                    //emit(ConnectionResult.Error("Connection was interrupted"))
                    Log.d(TAG, "Connection Error")
                    connectionStatus =  false
                }
            }

        return connectionStatus
    }

    override fun disconnectFromDevice(device: BluetoothDeviceEntity): Boolean {
        closeConnection()
        return true
    }



    override fun closeConnection() {
        currentClientSocket?.close()
        currentServerSocket?.close()
        currentClientSocket = null
        currentServerSocket = null
    }

    //Release the Broadcast receiver for memory management
    override fun release() {
        foundDeviceReceiver.unregisterAsReceiver(context)
        bluetoothStateReceiver.unregisterAsReceiver(context)
        closeConnection()
    }

    //Updates _pairedDevices with devices already known to the host device
    private fun updatePairedDevices() {
        Log.d(TAG, "androidBluetoothController - updatePairedDevices -> Entry")

        if(!hasPermission((Manifest.permission.BLUETOOTH_CONNECT))) {
            Log.d(TAG, "androidBluetoothController - updatePairedDevices -> No Manifest Permissions")
            return
        }

        if (bluetoothAdapter?.isEnabled == false) {
          return
        } else {
            bluetoothAdapter
                ?.bondedDevices
                ?.map { it.toBluetoothDeviceEntity() }
                ?.also { devices ->
                    _pairedDevices.update { devices }
                }
        }
    }

    fun getPairedDevices(): MutableList<Map<String, Any?>>{
        Log.d(TAG, "androidBluetoothController - getPairedBluetoothDevices -> Entry")


        if (bluetoothAdapter?.isEnabled == false) {
            Log.d(TAG, "androidBluetoothController - getPairedBluetoothDevices -> Bluetooth Not Enabled")
        }

        updatePairedDevices()

        var _bluetoothDevicesList:  MutableList<Map<String, Any?>> = mutableListOf()



        for (x in (0.._pairedDevices.value.size-1)) {
            val tempDevice: Map<String, Any?> = mapOf(
                "name" to _pairedDevices.value[x].name,
                "address" to _pairedDevices.value[x].address,
                "connectionStatus" to _pairedDevices.value[x].connectionStatus,
                "readerDetails" to _pairedDevices.value[x].readerDetails,
            )
            _bluetoothDevicesList.add(tempDevice)
        }

        Log.d(TAG, "androidBluetoothController - getPairedBluetoothDevices -> _bluetoothDevicesList - $_bluetoothDevicesList")
        //Log.d("LOGGER", _bluetoothDevicesList.toString())

        return _bluetoothDevicesList
    }

    //checks required permissions are granted in the Android Manifest and host device
    private fun hasPermission(permission: String): Boolean {
        return context.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED
    }

    companion object {
        const val SERVICE_UUID = "00001101-0000-1000-8000-00805F9B34FB"
    }

}