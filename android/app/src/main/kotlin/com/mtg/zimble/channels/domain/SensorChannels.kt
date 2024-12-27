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
    public lateinit var _sensorStreamAccelerometerChannel : EventChannel
    public lateinit var _sensorStreamGyroscopeChannel : EventChannel
    public lateinit var _sensorStreamLinearAccelerationChannel : EventChannel
    public lateinit var _sensorStreamRotationVectorChannel : EventChannel

    //Create a SensorManager Instance to pass
    private lateinit var _sensorManager: SensorManager

    ///Creates a Sensor Stream Handler instances to pass to the controller and collector
    var accelerometerStreamHandler = SensorStreamHandler(
        _sensorManager,
        Sensor.TYPE_ACCELEROMETER
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

        //Event Stream Channel for sensor streams
        _sensorStreamAccelerometerChannel = EventChannel(messenger, SENSOR_STREAM_ACCELEROMETER)
        _sensorStreamGyroscopeChannel = EventChannel(messenger, SENSOR_STREAM_GYROSCOPE)
        _sensorStreamLinearAccelerationChannel = EventChannel(messenger, SENSOR_STREAM_LINEAR_ACCELERATION)
        _sensorStreamRotationVectorChannel = EventChannel(messenger, SENSOR_STREAM_ROTATION_VECTOR)

        ///Assign StreamHandlers for each event channels
        _sensorStreamAccelerometerChannel.setStreamHandler(accelerometerStreamHandler)
        _sensorStreamGyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)
        _sensorStreamLinearAccelerationChannel.setStreamHandler(linearAccelerationStreamHandler)
        _sensorStreamRotationVectorChannel.setStreamHandler(rotationVectorStreamHandler)


        Log.d(TAG, "Sensor Streamchannels initialized ")


        //Define Sensor Method Calls
        _sensorMethodChannel.setMethodCallHandler { call, result ->
            when {
                /// Starts Stream of Accelerometer Sensor information
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type:
                call.method.equals("startSensors") -> {
                    Log.d(TAG, "in call method - startSensors")

                    result.success("success")
                }

                ///  Stops Stream of Accelerometer Sensor information
                /// Call Type: InvokeMethod
                /// Data Message Type: String
                /// Return Type:
                call.method.equals("stopSensors") -> {
                    Log.d(TAG, "in call method - stopSensors")

                    result.success("success")
                }
            }
        }
    }
}
