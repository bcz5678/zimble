package com.mtg.zimble.sensors.domain

import com.mtg.zimble.sensors.data.AccelerometerData
import com.mtg.zimble.sensors.data.GyroscopeData
import com.mtg.zimble.sensors.data.LinearAccelerationData
import com.mtg.zimble.sensors.data.RotationVectorData

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log
import io.flutter.plugin.common.EventChannel

class SensorStreamHandler(
    private val sensorManager: SensorManager,
    sensorType: Int,
    private var interval: Int,
    ):
        EventChannel.StreamHandler, SensorEventListener {

    val TAG = "SensorStreamHandler"

    private val sensor = sensorManager.getDefaultSensor(sensorType)
    private var sensorEventSink: EventChannel.EventSink? = null


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen")
        if (sensor != null){
            sensorEventSink = events
            sensorManager.registerListener(this, sensor, interval)
        }
    }

    override fun onSensorChanged(event: SensorEvent) {
        var sensorValues = when(event.sensor.type) {
            Sensor.TYPE_ACCELEROMETER -> {
                AccelerometerData(
                    event!!.values[0],
                    event!!.values[1],
                    event!!.values[2],
                ).toSensorData()
            }
            Sensor.TYPE_GYROSCOPE -> {
                GyroscopeData(
                    event!!.values[0],
                    event!!.values[1],
                    event!!.values[2],
                ).toSensorData()
            }
            Sensor.TYPE_LINEAR_ACCELERATION -> {
                LinearAccelerationData(
                    event!!.values[0],
                    event!!.values[1],
                    event!!.values[2],
                ).toSensorData()
            }
            Sensor.TYPE_ROTATION_VECTOR -> {
                RotationVectorData(
                    event!!.values[0],
                    event!!.values[1],
                    event!!.values[2],
                    event!!.values[3],
                ).toSensorData()
            }
            else -> {
                null
            }
        }

        //Log.d(TAG, sensorValues.toString())
        sensorEventSink?.success(sensorValues.toString())
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        sensorManager.unregisterListener(this)
        sensorEventSink = null
    }

/*
    override fun onResume() {
        super.onResume()
        sensorManager.registerListener(this, sensor, interval)
        // Register other sensors similarly
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
        // Unregister other sensors similarly
    }
 */

}