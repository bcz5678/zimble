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
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceEntity
import com.mtg.zimble.connection.bluetooth.domain.BluetoothController
import com.mtg.zimble.connection.bluetooth.domain.BluetoothDeviceScanningStreamHandler
import com.mtg.zimble.connection.bluetooth.domain.ConnectionResult
import com.mtg.zimble.connection.bluetooth.domain.bluetoothScanningCollector
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.Dispatchers

import java.io.IOException
import java.util.UUID
import android.util.Log



//import com.mtg.zimble.bluetooth.data.BluetoothEnableActivity



@SuppressLint("MissingPermission")
class  AndroidBluetoothController(
    private val context: Context,
): BluetoothController {


    //Setting up the Bluetooth manager and adapter for use
    private val bluetoothManager by lazy {
        context.getSystemService(BluetoothManager::class.java)
    }
    private val bluetoothAdapter by lazy {
        bluetoothManager?.adapter
    }


    // StateFlow for scanned devices
    private val _scannedDevices = MutableStateFlow<List<BluetoothDeviceEntity>>(emptyList())
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
        context.registerReceiver(
            bluetoothStateReceiver,
            IntentFilter().apply {
                addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED)
                addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
                addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
            },
            RECEIVER_EXPORTED
        )
    }

    //Start scan for available Bluetooth devices
    override fun startDiscovery(streamHandlerInstanceTest: BluetoothDeviceScanningStreamHandler){
        //stop previous discovery that may still be in background
        if(bluetoothAdapter?.isDiscovering() == true) {
            bluetoothAdapter?.cancelDiscovery()
            release()
        }

        Log.d("LOGGING", "in startDiscovery")
        //Check we have manifest permissions for scanning
        if(!hasPermission(Manifest.permission.BLUETOOTH_SCAN)) {
            return
        }

        //_scannedDevices.update(emptyList())

       // Log.d("LOGGING", "streamHandlerInstanceTest Hash Code - ${streamHandlerInstanceTest.hashCode()}") //Log.d("LOGGING", "streamHandlerInstanceTest Reference Code - ${Integer.toHexString(System.identityHashCode(streamHandlerInstanceTest))}")

        //Initialize the Stateflow Collector to receive devices state changes
        bluetoothScanningCollector(streamHandlerInstanceTest, scannedDevices)

        /*
        if (bluetoothAdapter?.isEnabled == false) {
            BluetoothEnableActivity.promptForBluetoothEnable()
        }
        */

        Log.d("LOGGER", "ABTC - startDiscovery")

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(
                foundDeviceReceiver,
                IntentFilter(BluetoothDevice.ACTION_FOUND),
                RECEIVER_EXPORTED,
            )
        } else {
            context.registerReceiver(
                foundDeviceReceiver,
                IntentFilter(BluetoothDevice.ACTION_FOUND),
            )
        }

        // update paired devices before discovery
        updatePairedDevices()

        //start new scan
        bluetoothAdapter?.startDiscovery()
    }

    //Stop scan for available Bluetooth devices
    override fun stopDiscovery() {
        if(!hasPermission(Manifest.permission.BLUETOOTH_SCAN)) {
            return
        }

        Log.d("LOGGING", "ABTC - stopDiscovery")

        bluetoothAdapter?.cancelDiscovery()

        release()
    }

/*
    override fun startBluetoothServer(): Flow<ConnectionResult> {
        return flow {
            if(!hasPermission((Manifest.permission.BLUETOOTH_CONNECT))) {
                throw SecurityException("No BLUETOOTH_CONNECT permission")
            }

            currentServerSocket = bluetoothAdapter?.listenUsingRfcommWithServiceRecord(
                "MTG_RFID Service",
                    UUID.fromString(SERVICE_UUID)
            )

            var shouldListen = true
            while(shouldListen) {
                currentClientSocket = try{
                    currentServerSocket?.accept()
                } catch (e: IOException) {
                    shouldListen = false
                    null
                }
                emit(ConnectionResult.ConnectionEstablished)
                currentClientSocket?.let {
                    currentServerSocket?.close()
                }
            }
        }.onCompletion {
            closeConnection()
        }.flowOn(Dispatchers.IO)
    }


 */
    fun connectToDevice_old(device: BluetoothDeviceEntity): Flow<ConnectionResult> {
        Log.d("LOGGER", "In ABTC - connectToDevice")
        return flow {
            if(!hasPermission((Manifest.permission.BLUETOOTH_CONNECT))) {
                throw SecurityException("No BLUETOOTH_CONNECT permission")
            }
            Log.d("LOGGER", "In ABTC - connectToDevice FLOW")

            if (bluetoothAdapter?.isDiscovering() == true) {
                stopDiscovery()
            }

            currentClientSocket = bluetoothAdapter
                ?.getRemoteDevice(device.address)
                ?.createRfcommSocketToServiceRecord(
                    UUID.fromString(SERVICE_UUID)
                )
            Log.d("LOGGER", "currentClientSocket - ${currentClientSocket.toString()}")


            currentClientSocket?.let{ socket ->
                try {
                    socket.connect()
                    emit(ConnectionResult.ConnectionEstablished(device.address))
                    Log.d("LOGGER", "Connection Established")
                } catch (e: IOException) {
                    socket.close()
                    currentClientSocket = null
                    emit(ConnectionResult.Error("Connection was interrupted"))
                }
            }
        }.onCompletion {
            //closeConnection()
            Log.d("LOGGER", "In ABTC - in onCompletion")

        }.flowOn(Dispatchers.IO)
    }

    override fun connectToDevice(device: BluetoothDeviceEntity): String {
        Log.d("LOGGER", "In ABTC - connectToDevice")

            var connectionStatus: String  = "";

            if(!hasPermission((Manifest.permission.BLUETOOTH_CONNECT))) {
                throw SecurityException("No BLUETOOTH_CONNECT permission")
            }

            Log.d("LOGGER", "In ABTC - connectToDevice FLOW")

            if (bluetoothAdapter?.isDiscovering() == true) {
                stopDiscovery()
            }

            currentClientSocket = bluetoothAdapter
                ?.getRemoteDevice(device.address)
                ?.createRfcommSocketToServiceRecord(
                    UUID.fromString(SERVICE_UUID)
                )
            Log.d("LOGGER", "currentClientSocket - ${currentClientSocket.toString()}")

            currentClientSocket?.let{ socket ->
                try {
                    socket.connect()
                    //emit(ConnectionResult.ConnectionEstablished(device.address))
                    Log.d("LOGGER", "Connection Established")
                    connectionStatus = "isConnected"
                } catch (e: IOException) {
                    socket.close()
                    currentClientSocket = null
                    //emit(ConnectionResult.Error("Connection was interrupted"))
                    Log.d("LOGGER", "Connection Error")
                    connectionStatus =  "notConnected"
                }
            }

        return connectionStatus
    }

    override fun disconnectFromDevice(device: BluetoothDeviceEntity): String {
        closeConnection()
        return "notConnected"
    }



    override fun closeConnection() {
        currentClientSocket?.close()
        currentServerSocket?.close()
        currentClientSocket = null
        currentServerSocket = null
    }

    //Release the Broadcast receiver for memory management
    override fun release() {
        context.unregisterReceiver(foundDeviceReceiver)
        context.unregisterReceiver(bluetoothStateReceiver)
        closeConnection()
    }

    //Updates _pairedDevices with devices already known to the host device
    private fun updatePairedDevices() {
        Log.d("AndroidBluetoothController", "androidBluetoothController - updatePairedDevices -> Entry")

        if(!hasPermission((Manifest.permission.BLUETOOTH_CONNECT))) {
            Log.d("AndroidBluetoothController", "androidBluetoothController - updatePairedDevices -> No Manifest Permissions")
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
        Log.d("AndroidBluetoothController", "androidBluetoothController - getPairedBluetoothDevices -> Entry")


        if (bluetoothAdapter?.isEnabled == false) {
            Log.d("AndroidBluetoothController", "androidBluetoothController - getPairedBluetoothDevices -> Bluetooth Not Enabled")
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

        Log.d("AndroidBluetoothController", "androidBluetoothController - getPairedBluetoothDevices -> _bluetoothDevicesList - $_bluetoothDevicesList")
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