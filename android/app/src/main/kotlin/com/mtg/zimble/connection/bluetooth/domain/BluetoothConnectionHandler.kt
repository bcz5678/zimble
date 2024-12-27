package com.mtg.zimble.connection.bluetooth.domain


import android.content.Context

class BluetoothConnectionHandler (
    private val bluetoothController: BluetoothController,
    private val context: Context,
) {
/*
    private var deviceConnectionJob: Job? = null

    private var _pairedDevicesOnStart: List<BluetoothDeviceEntity>? = emptyList()

    private var _state = MutableStateFlow(BluetoothConnectionState())

    //Setting up the Bluetooth manager and adapter for use
    private val bluetoothManager by lazy {
        context.getSystemService(BluetoothManager::class.java)
    }
    private val bluetoothAdapter by lazy {
        bluetoothManager?.adapter
    }


    init {
        /*
        Log.d("LOGGER", "In BCH Init")
        bluetoothController.isConnected.onEach { isConnected: Boolean ->
            _state.update { it.copy(isConnected = isConnected) }
        }.launchIn(CoroutineScope(Dispatchers.IO))

        bluetoothController.errors.onEach { error: String? ->
            _state.update { it.copy(
                errorMessage = error
            ) }
        }.launchIn(CoroutineScope(Dispatchers.IO))

         */
    }

    @SuppressLint("MissingPermission")
    fun checkBluetoothDeviceConnectedAtStartup(): List<BluetoothDeviceEntity>? {
        var _connectedDevicesOnStartup: MutableList<BluetoothDeviceEntity>? = null;

        if(!(context.checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED)) {
            return null
        } else if (bluetoothAdapter?.isEnabled == false) {
            return null
        } else {
            _pairedDevicesOnStart = bluetoothAdapter
                ?.bondedDevices
                ?.map { it.toBluetoothDeviceEntity() }
        }

        if (_pairedDevicesOnStart!!.isNotEmpty()) {

            _pairedDevicesOnStart!!.forEach {
                var tempSocket = bluetoothAdapter
                    ?.getRemoteDevice(it.address)
                    ?.createRfcommSocketToServiceRecord(
                        UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
                    )
                try {
                    tempSocket?.isConnected()
                    Log.d("LOGGER", "Connected to ${it.address}")
                    _connectedDevicesOnStartup?.add(it)
                } catch (e: IOException) {
                    tempSocket?.close()
                    Log.d("LOGGER", "NOT Connected to ${it.address}")
                }
            }
        }
        return _connectedDevicesOnStartup
    }

    fun connectToDevice(device: BluetoothDeviceEntity)  {
        Log.d("LOGGER", "in BCH - connectToDevice - ${device.address}")
        _state.update { it.copy(isConnecting = true) }
        deviceConnectionJob = bluetoothController
            .connectToDevice(device)
            .listen()
    }

    fun disconnectFromDevice(device:BluetoothDeviceEntity): String {
        deviceConnectionJob?.cancel()
        bluetoothController.closeConnection()
        _state.update { it.copy(
            isConnecting = false,
            isConnected = false
        ) }
        return "notConnected";
    }

    fun getCurrentState() {
        Log.d("LOGGER", "BTCH - getCurrentState - ${_state.value}")
    }


    private fun Flow<ConnectionResult>.listen(): Job {
        return onEach { result ->
            when(result) {
                is ConnectionResult.ConnectionEstablished -> {
                    _state.update {
                        it.copy(
                            isConnected = true,
                            isConnecting = false,
                            errorMessage = null,
                            MACAddress = result.MACAddress
                        )
                    }
                    Log.d("LOGGER", "BCH - listen.onEach - ConnectionEstablished - ${result.MACAddress}")
                }
                is ConnectionResult.Error -> {
                    _state.update {
                        it.copy(
                            isConnected = false,
                            isConnecting = false,
                            errorMessage = result.message,
                            //MACAddress = result.MACAddress
                        )
                    }
                }
            }
        } .catch { throwable ->
            bluetoothController.closeConnection()
            _state.update {
                it.copy(
                    isConnected = false,
                    isConnecting = false
                )
            }
        }.launchIn(CoroutineScope(Dispatchers.Main))
    }


    fun waitForIncomingConnections() {
        _state.update { it.copy(isConnecting = true) }
        deviceConnectionJob = bluetoothController
            .startBluetoothServer()
            .listen()
    }

     */
}