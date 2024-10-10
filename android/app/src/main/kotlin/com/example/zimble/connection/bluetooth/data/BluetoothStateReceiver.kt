package com.example.zimble.connection.bluetooth.data

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

class BluetoothStateReceiver(
    private val onStateChanged: (isConnected: Boolean, BluetoothDevice) -> Unit
): BroadcastReceiver() {

    val TAG = "BluetoothStateReceiver"

    @SuppressLint("MissingPermission")
    override fun onReceive(context: Context?, intent: Intent?) {
        val device = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent?.getParcelableExtra(
                BluetoothDevice.EXTRA_DEVICE,
                BluetoothDevice::class.java
            )
        } else {
            intent?.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
        }

        when(intent?.action) {
            BluetoothDevice.ACTION_ACL_CONNECTED -> {
                Log.d(TAG, "in BSR - setting isConnected to True")
                onStateChanged(true, device ?: return)
            }
            BluetoothDevice.ACTION_ACL_DISCONNECTED -> {
                Log.d(TAG, "in BSR - setting isConnected to False")
                onStateChanged(false, device ?: return)
            }
        }
    }
}