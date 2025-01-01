package com.mtg.zimble.sensors.domain

import com.mtg.zimble.sensors.data.AccelerometerData
import com.mtg.zimble.sensors.data.GyroscopeData
import com.mtg.zimble.sensors.data.LinearAccelerationData
import com.mtg.zimble.sensors.data.RotationVectorData

import android.hardware.Sensor as Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class SensorStreamHandler(
    private val sensorManager: SensorManager,
    sensorType: Int,
    private var interval: Int = SensorManager.SENSOR_DELAY_NORMAL
    ):
        EventChannel.StreamHandler, SensorEventListener {

    private val sensor = sensorManager.getDefaultSensor(sensorType)
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (sensor != null){
            eventSink = events
            sensorManager.registerListener(this, sensor, interval)
        }
    }

    override fun onSensorChanged(event: SensorEvent) {
        var sensorValues = when(event.sensor.type) {
            Sensor.TYPE_ACCELEROMETER -> {
                AccelerometerData(event!!.values[0], event!!.values[1], event!!.values[2])
            }
            Sensor.TYPE_GYROSCOPE ->{
                GyroscopeData(event!!.values[0], event!!.values[1], event!!.values[2])
            }
            Sensor.TYPE_LINEAR_ACCELERATION ->{
                LinearAccelerationData(event!!.values[0], event!!.values[1], event!!.values[2])
            }
            Sensor.TYPE_ROTATION_VECTOR ->{
                RotationVectorData(event!!.values[0], event!!.values[1], event!!.values[2], event!!.values[3])
            }
            else -> {
                null
            }
        }
        eventSink?.success(sensorValues)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {

    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        eventSink = null
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