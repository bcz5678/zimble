package com.mtg.zimble.channels.domain

import com.mtg.zimble.channels.data.MethodMapData
import com.mtg.zimble.sensors.domain.SensorStreamHandler

import android.hardware.Sensor
import android.hardware.SensorManager

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.util.Log


class SensorChannels(context: Context) {
    val TAG = "SensorChannels"

    ///Create Stream Channel Names to match Flutter
    private val SENSOR_METHOD = "mtg_rfid_method/reader/sensor_method"
    private val SENSOR_STREAM_ACCELEROMETER = "mtg_rfid_event/reader/stream_accelerometer"
    private val SENSOR_STREAM_GYROSCOPE = "mtg_rfid_event/reader/stream_gyroscope"
    private val SENSOR_STREAM_LINEAR_ACCELERATION = "mtg_rfid_event/reader/stream_linear_acceleration"
    private val SENSOR_STREAM_ROTATION_VECTOR = "mtg_rfid_event/reader/stream_rotation_vector"


    ///Create the Channels to use to transfer data
    private lateinit var _sensorMethodChannel : MethodChannel
    public lateinit var sensorStreamAccelerometerChannel : EventChannel
    public lateinit var sensorStreamGyroscopeChannel : EventChannel
    public lateinit var sensorStreamLinearAccelerationChannel : EventChannel
    public lateinit var sensorStreamRotationVectorChannel : EventChannel

    //Create a SensorManager Instance to pass
    private var _sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    ///Creates a Sensor Stream Handler instances to pass to the controller and collector
    var accelerometerStreamHandler = SensorStreamHandler(
        _sensorManager,
        Sensor.TYPE_ACCELEROMETER,
    )

    var gyroscopeStreamHandler = SensorStreamHandler(
        _sensorManager,
        Sensor.TYPE_GYROSCOPE
    )

    var linearAccelerationStreamHandler = SensorStreamHandler(
        _sensorManager,
        Sensor.TYPE_LINEAR_ACCELERATION
    )

    var rotationVectorStreamHandler = SensorStreamHandler(
        _sensorManager,
        Sensor.TYPE_ROTATION_VECTOR
    )


    fun initializeSensorChannels(messenger: BinaryMessenger) {
        Log.d(TAG, "initializing Sensor Android Channels")

        //Bluetooth Method Channel for calls from Features->Reader
        _sensorMethodChannel = MethodChannel(messenger, SENSOR_METHOD)
        Log.d(TAG, "Sensor Methodchannel initialized ")

        Log.d(TAG, "_sensorManager - ${_sensorManager}")
        Log.d(TAG, "accelerometerStreamHandler - ${accelerometerStreamHandler.testVariable}")


        //Event Stream Channel for sensor streams
        sensorStreamAccelerometerChannel = EventChannel(messenger, SENSOR_STREAM_ACCELEROMETER)
        sensorStreamGyroscopeChannel = EventChannel(messenger, SENSOR_STREAM_GYROSCOPE)
        sensorStreamLinearAccelerationChannel = EventChannel(messenger, SENSOR_STREAM_LINEAR_ACCELERATION)
        sensorStreamRotationVectorChannel = EventChannel(messenger, SENSOR_STREAM_ROTATION_VECTOR)

        ///Assign StreamHandlers for each event channels
        sensorStreamAccelerometerChannel.setStreamHandler(accelerometerStreamHandler)
        sensorStreamGyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)
        sensorStreamLinearAccelerationChannel.setStreamHandler(linearAccelerationStreamHandler)
        sensorStreamRotationVectorChannel.setStreamHandler(rotationVectorStreamHandler)


        Log.d(TAG, "SensorStreamchannels initialized ")


        //Define Sensor Method Calls
        _sensorMethodChannel.setMethodCallHandler { call, result ->
            when {
                /// Starts Stream of Sensor information
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type:
                call.method.equals("startSensorStream") -> {
                    Log.d(TAG, "in call method - startSensors")

                    try {

                        accelerometerStreamHandler.initialize()
                        gyroscopeStreamHandler.initialize()
                        linearAccelerationStreamHandler.initialize()
                        rotationVectorStreamHandler.initialize()

                        Log.d(TAG, "in call method - startSensors - success")
                        result.success("success")
                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - startSensors - error")
                        result.error("sensorStreamError", "There was a problem starting the Sensor Stream", null)
                    }
                }

                ///  Stops Stream of Accelerometer Sensor information
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type:
                call.method.equals("stopSensorStream") -> {
                    Log.d(TAG, "in call method - stopSensors")
                    try {
                        ///Assign StreamHandlers for each event channels
                        sensorStreamAccelerometerChannel.setStreamHandler(null)
                        sensorStreamGyroscopeChannel.setStreamHandler(null)
                        sensorStreamLinearAccelerationChannel.setStreamHandler(null)
                        sensorStreamRotationVectorChannel.setStreamHandler(null)

                        accelerometerStreamHandler.destroy()
                        gyroscopeStreamHandler.destroy()
                        linearAccelerationStreamHandler.destroy()
                        rotationVectorStreamHandler.destroy()

                        Log.d(TAG, "in call method - stopSensors - success")
                        result.success("success")
                    } catch (e: Exception) {
                        Log.d(TAG, "in call method - stopSensors - error")
                        result.error("sensorStreamError", "There was a problem stopping the Sensor Stream", null)
                    }
                }
            }
        }
    }
}
