package com.example.untitled.connection.bluetooth.domain

data class BluetoothConnectionState (
        val isConnected: Boolean = false,
        val isConnecting: Boolean = false,
        val errorMessage: String? = null,
        val MACAddress: String? = null,
)