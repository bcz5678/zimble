package com.mtg.zimble.connection.bluetooth.data

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.RECEIVER_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.util.Log

class BluetoothStateReceiver(
    private val onStateChanged: (isConnected: Boolean, BluetoothDevice) -> Unit
): BroadcastReceiver() {

    val TAG = "BluetoothStateReceiver"

    var isRegistered : Boolean = false

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

    fun registerAsReceiver(context: Context?):  Intent? {
        if (!isRegistered) {
            try {
                var receiver = context?.registerReceiver(
                    this,
                    IntentFilter().apply {
                        addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED)
                        addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
                        addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
                    },
                    RECEIVER_EXPORTED
                )
                isRegistered = true
                return receiver
            } catch (e: Exception) {
                Log.d(TAG, "unable to register Receiver")
                return null
            }
        } else {
            Log.d(TAG, "Receiver is already registered")
            return null
        }
    }

    fun unregisterAsReceiver(context: Context?):  Unit {
        if (isRegistered) {
            try {
                context?.unregisterReceiver(this)
                isRegistered = false
            } catch (e: Exception) {
                Log.d(TAG, "unable to unregister Receiver")
            }
        } else {
            Log.d(TAG, "Receiver is not registered")
        }
    }

}