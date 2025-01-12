package com.mtg.zimble.channels.domain

import com.mtg.zimble.channels.data.MethodMapData
//import com.mtg.zimble.sensors.domain.SensorListenerBase
//import com.mtg.zimble.sensors.domain.SensorStreamHandlerBase
import com.mtg.zimble.sensors.domain.SensorStreamHandler

import android.hardware.Sensor
import android.hardware.SensorManager as SensorManager

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.util.Log

class SensorChannels(context: Context, messenger: BinaryMessenger) {
    val TAG = "SensorChannels"

    ///Create Stream Channel Names to match Flutter
    private val METHOD_SENSOR = "mtg_rfid_method/reader/sensor_method"
    private val STREAM_SENSOR_ACCELEROMETER = "mtg_rfid_event/reader/sensor_stream_accelerometer"
    private val STREAM_SENSOR_GYROSCOPE = "mtg_rfid_event/reader/sensor_stream_gyroscope"
    private val STREAM_SENSOR_LINEAR_ACCELERATION = "mtg_rfid_event/reader/sensor_stream_linear_acceleration"
    private val STREAM_SENSOR_ROTATION_VECTOR = "mtg_rfid_event/reader/sensor_stream_rotation_vector"


    ///Create the Channels to use to transfer data
    private lateinit var _sensorMethodChannel : MethodChannel
    lateinit var sensorStreamAccelerometerChannel : EventChannel
    lateinit var sensorStreamGyroscopeChannel : EventChannel
    lateinit var sensorStreamLinearAccelerationChannel : EventChannel
    lateinit var sensorStreamRotationVectorChannel : EventChannel

    init {
        initializeSensorChannels(context, messenger)
    }

    //Create a SensorManager Instance to pass
    val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    ///Creates a Sensor Stream Handler instances to pass to the controller and collector
    var accelerometerStreamHandler = SensorStreamHandler(
        sensorManager,
        Sensor.TYPE_ACCELEROMETER,
        SensorManager.SENSOR_DELAY_NORMAL,
    )

    var gyroscopeStreamHandler = SensorStreamHandler(
        sensorManager,
        Sensor.TYPE_GYROSCOPE,
        SensorManager.SENSOR_DELAY_NORMAL,
    )

    var linearAccelerationStreamHandler = SensorStreamHandler(
        sensorManager,
        Sensor.TYPE_LINEAR_ACCELERATION,
        SensorManager.SENSOR_DELAY_NORMAL,
    )

    var rotationVectorStreamHandler = SensorStreamHandler(
        sensorManager,
        Sensor.TYPE_ROTATION_VECTOR,
        SensorManager.SENSOR_DELAY_NORMAL,
    )

    fun initializeSensorChannels(context:Context, messenger: BinaryMessenger) {
        val accelerometerChannel = EventChannel(messenger, STREAM_SENSOR_ACCELEROMETER)


        Log.d(TAG, "context -> ${context.toString()}")
        Log.d(TAG, "messenger -> ${messenger.toString()}")


        Log.d(TAG, "initializing Sensor Android Channels")

        //Bluetooth Method Channel for calls from Features->Reader
        _sensorMethodChannel = MethodChannel(messenger, METHOD_SENSOR)
        Log.d(TAG, "Sensor MethodChannel initialized ")


        //Event Stream Channel for sensor streams
        sensorStreamAccelerometerChannel = EventChannel(messenger, STREAM_SENSOR_ACCELEROMETER)
        sensorStreamGyroscopeChannel = EventChannel(messenger, STREAM_SENSOR_GYROSCOPE)
        sensorStreamLinearAccelerationChannel = EventChannel(messenger, STREAM_SENSOR_LINEAR_ACCELERATION)
        sensorStreamRotationVectorChannel = EventChannel(messenger, STREAM_SENSOR_ROTATION_VECTOR)

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

                        ///Assign StreamHandlers for each event channels
                        sensorStreamAccelerometerChannel.setStreamHandler(accelerometerStreamHandler)
                        sensorStreamGyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)
                        sensorStreamLinearAccelerationChannel.setStreamHandler(linearAccelerationStreamHandler)
                        sensorStreamRotationVectorChannel.setStreamHandler(rotationVectorStreamHandler)

                        result.success("sensorStreamSuccess")
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
                    try{
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
