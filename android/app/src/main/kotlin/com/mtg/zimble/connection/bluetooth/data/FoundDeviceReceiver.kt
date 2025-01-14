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

class FoundDeviceReceiver(
    private val onDeviceFound: (BluetoothDevice) -> Unit
): BroadcastReceiver() {

    val TAG = "FoundDeviceReceiver"

    var isRegistered : Boolean = false

    @SuppressLint("MissingPermission")
    override fun onReceive(context: Context?, intent: Intent?) {
         when(intent?.action) {
            BluetoothDevice.ACTION_FOUND -> {
                val device = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableExtra(
                        BluetoothDevice.EXTRA_DEVICE,
                        BluetoothDevice::class.java
                    )
                } else {
                    intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                }
                device?.let(onDeviceFound)
            }
        }
    }

    fun registerAsReceiver(context: Context?):  Intent? {
        if (!isRegistered) {
            try {

                var receiver : Intent? = null;

                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    receiver = context?.registerReceiver(
                        this,
                        IntentFilter(BluetoothDevice.ACTION_FOUND),
                        RECEIVER_EXPORTED,
                    )
                } else {
                    receiver = context?.registerReceiver(
                        this,
                        IntentFilter(BluetoothDevice.ACTION_FOUND),
                    )
                }


                isRegistered = true
                Log.d(TAG, "Receiver is registered")
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
                Log.d(TAG, "Receiver is unregistered")
            } catch (e: Exception) {
                Log.d(TAG, "unable to unregister Receiver")
            }
        } else {
            Log.d(TAG, "Receiver is not registered")
        }
    }

}