package com.example.untitled.connection.bluetooth.domain

sealed interface ConnectionResult {
    data class ConnectionEstablished(val MACAddress: String): ConnectionResult
    data class Error(val message: String): ConnectionResult
}