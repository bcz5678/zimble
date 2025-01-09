import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_channels_client/native_channels_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reader_client/reader_client.dart';


/// Exceptions from the authentication client.
abstract class ReaderClientException implements Exception {
  const ReaderClientException(this.error);

  /// The error which was caught.
  final Object error;
}

/// Thrown during process of starting an open sensor stream from the device.
class StartSensorStreamFailure extends ReaderClientException {
  const  StartSensorStreamFailure(super.error);
}

/// Thrown during process of closing the sensor stream from the device
class StopSensorStreamFailure extends ReaderClientException {
  const  StopSensorStreamFailure(super.error);
}


/// Reader client
class ReaderClient {
  ReaderClient();

  var sensorMethodChannel = NativeChannels().sensorMethod;
  var sensorAccelerometerStreamChannel = NativeChannels().sensorAccelerometerStream;
  var sensorGyroscopeStreamChannel = NativeChannels().sensorGyroscopeStream;
  var sensorLinearAccelerationStreamChannel = NativeChannels().sensorLinearAccelerationStream;
  var sensorRotationVectorStreamChannel = NativeChannels().sensorRotationVectorStream;


  // Subscription to listen and process sensor Event Channel Data
  late StreamSubscription<dynamic> _sensorAccelerometerSubscription;
  late StreamSubscription<dynamic> _sensorGyroscopeSubscription;
  late StreamSubscription<dynamic> _sensorLinearAccelerationSubscription;
  late StreamSubscription<dynamic> _sensorRotationVectorSubscription;

  // Post Processed stream from the _sensorChannelSubscription
  // Used to set the sensorStream getter to pass to ReaderRepository
  late BehaviorSubject<AccelerometerData> _sensorAccelerometerStream = BehaviorSubject<AccelerometerData>.seeded(AccelerometerData());
  late BehaviorSubject<GyroscopeData> _sensorGyroscopeStream = BehaviorSubject<GyroscopeData>.seeded(GyroscopeData());
  late BehaviorSubject<LinearAccelerationData> _sensorLinearAccelerationStream = BehaviorSubject<LinearAccelerationData>.seeded(LinearAccelerationData());
  late BehaviorSubject<RotationVectorData> _sensorRotationVectorStream = BehaviorSubject<RotationVectorData>.seeded(RotationVectorData());




  /// Stream of [BluetoothReader] which will emit the current reader when
  /// the connection process changes
  //Stream<BluetoothReader> get bluetoothReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<NetworkReader> get networkReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<UsbReader> get usbReader;

  /// Stream of [SensorData] which will emit current sensor data streaming
  /// from the attached mobile device
  Stream<SensorData> get streamSensorDataAll =>
      Rx.combineLatest4<AccelerometerData, GyroscopeData,
          LinearAccelerationData, RotationVectorData,
          SensorData>
        ( _sensorAccelerometerStream.stream,
          _sensorGyroscopeStream.stream,
          _sensorLinearAccelerationStream.stream,
          _sensorRotationVectorStream.stream,
          ( AccelerometerData,
            GyroscopeData,
            LinearAccelerationData,
            RotationVectorData,
          ) => SensorData(
            accelerometerData: AccelerometerData,
            gyroscopeData: GyroscopeData,
            linearAccelerationData: LinearAccelerationData,
            rotationVectorData: RotationVectorData,
          ),
      ).asBroadcastStream();


  /// Stream of [AccelerometerData] which will emit current sensor Accelerometer data streaming
  /// from the attached mobile device
  Stream<AccelerometerData> get streamSensorDataAccelerometer => _sensorAccelerometerStream;

  /// Stream of [GyroscopeData] which will emit current sensor Gyroscope data streaming
  /// from the attached mobile device
  Stream<GyroscopeData> get streamSensorDataGyroscope => _sensorGyroscopeStream;

  /// Stream of [LinearAccelerationData] which will emit current sensor LinearAcceleration data streaming
  /// from the attached mobile device
  Stream<LinearAccelerationData> get streamSensorDataLinearAcceleration => _sensorLinearAccelerationStream;

  /// Stream of [RotationVectorData] which will emit current sensor RotationVector data streaming
  /// from the attached mobile device
  Stream<RotationVectorData> get streamSensorDataRotationVector => _sensorRotationVectorStream;


  ///Starts Stream of sensorData to pass to the Reader_repository
  Future<bool> startSensorStream() async {
    try {
      if (kDebugMode) {
        print('reader_client -> startSensorStream -> Entry');
      }

      // Call Method Channel to start and set the EventChannel streamHandlers
      final startSensorStreamResult = await sensorMethodChannel.invokeMethod(
          "startSensorStream").toString();

      // Start _sensorAccelerometerSubscription listening to the EventChannel
      // and format results
      _sensorAccelerometerSubscription =
        sensorAccelerometerStreamChannel
            .receiveBroadcastStream()
            .distinct()
            .listen((event) {

              // Decode all the event string json into the base of
              // nested components to see return type (ie sensorData)
              Map<String, dynamic>? sensorEvent = json.decode(event.toString()) as Map<String, dynamic>;

              /// [ANCHOR]  - sensorData is full but have not json.decoded below that
              // If sensorData is present, encode the sensor into
              // SensorData entity and add to _sensorStream for getter
              if(sensorEvent.containsKey("sensorData")) {
                if (sensorEvent["sensorData"]["sensorType"] == "accelerometer") {
                  try {
                    _sensorAccelerometerStream.add(
                        AccelerometerData.fromJson(
                            sensorEvent["sensorData"]["sensorDataMap"] as Map<String, dynamic>,
                        ),
                    );
                  } catch (error) {
                    if (kDebugMode) {
                      print(
                          'reader_client -> startSensorStream -> acceleromter -> _sensorStream.add -> ${error
                              .toString()}');
                    }
                  }
                }
              }
            }
      );

      // Start _sensorGyroscopeSubscription listening to the EventChannel
      // and format results
      _sensorGyroscopeSubscription =
          sensorGyroscopeStreamChannel
              .receiveBroadcastStream()
              .distinct()
              .listen((event) {

            // Decode all the event string json into the base of
            // nested components to see return type (ie sensorData)
            Map<String, dynamic>? sensorEvent = json.decode(event.toString()) as Map<String, dynamic>;

            /// [ANCHOR]  - sensorData is full but have not json.decoded below that
            // If sensorData is present, encode the sensor into
            // SensorData entity and add to _sensorStream for getter
            if(sensorEvent.containsKey("sensorData")) {
              if (sensorEvent["sensorData"]["sensorType"] == "gyroscope") {
                try {
                  _sensorGyroscopeStream.add(
                    GyroscopeData.fromJson(
                        sensorEvent["sensorData"]["sensorDataMap"] as Map<String, dynamic>,
                    ),
                  );
                } catch (error) {
                  if (kDebugMode) {
                    print(
                        'reader_client -> startSensorStream ->gyroscope -> _sensorStream.add -> ${error
                            .toString()}');
                  }
                }
              }
            }
          }
        );

      // Start _sensorLinearAccelerationSubscription listening to the EventChannel
      // and format results
      _sensorLinearAccelerationSubscription =
          sensorLinearAccelerationStreamChannel
              .receiveBroadcastStream()
              .distinct()
              .listen((event) {

            // Decode all the event string json into the base of
            // nested components to see return type (ie sensorData)
            Map<String, dynamic>? sensorEvent = json.decode(event.toString()) as Map<String, dynamic>;


            /// [ANCHOR]  - sensorData is full but have not json.decoded below that
            // If sensorData is present, encode the sensor into
            // SensorData entity and add to _sensorStream for getter
            if(sensorEvent.containsKey("sensorData")) {
              if (sensorEvent["sensorData"]["sensorType"] == "linearAcceleration") {
                try {
                  _sensorLinearAccelerationStream.add(
                    LinearAccelerationData.fromJson(
                      sensorEvent["sensorData"]["sensorDataMap"] as Map<String, dynamic>,
                    ),
                  );
                } catch (error) {
                  if (kDebugMode) {
                    print(
                        'reader_client -> startSensorStream -> linearAcceleration -> _sensorStream.add -> ${error.toString()}');
                  }
                }
              }
            }
          }
        );

      // Start _sensorRotationVectorSubscription listening to the EventChannel
      // and format results
      _sensorRotationVectorSubscription =
          sensorRotationVectorStreamChannel
              .receiveBroadcastStream()
              .distinct()
              .listen((event) {

            // Decode all the event string json into the base of
            // nested components to see return type (ie sensorData)
            Map<String, dynamic>? sensorEvent = json.decode(event.toString()) as Map<String, dynamic>;

            if (kDebugMode) {
              print('reader_client -> startSensorStream -> EventChannelData -> ${sensorEvent}');
            }
            /// [ANCHOR]  - sensorData is full but have not json.decoded below that
            // If sensorData is present, encode the sensor into
            // SensorData entity and add to _sensorStream for getter
            if(sensorEvent.containsKey("sensorData")) {
              if (sensorEvent["sensorData"]["sensorType"] == "rotationVector") {
                try {
                  _sensorRotationVectorStream.add(
                    RotationVectorData.fromJson(
                      sensorEvent["sensorData"]["sensorDataMap"] as Map<String, dynamic>,
                    ),
                  );
                } catch (error) {
                  if (kDebugMode) {
                    print(
                        'reader_client -> startSensorStream -> rotationVector -> _sensorStream.add -> ${error.toString()}');
                  }
                }
              }
            }
          }
        );


      // Return value that the stream has started successfully
      return true;

    } on PlatformException catch (e) {
      // Native side returns error on start
      if (kDebugMode) {
        print('reader_client -> startSensorStream -> Error: ${e.message}');
      }

      // Cancels the newly started _sensorChannelSubscription to free resources
      await _sensorAccelerometerSubscription.cancel();
      await _sensorGyroscopeSubscription.cancel();
      await _sensorLinearAccelerationSubscription.cancel();
      await _sensorRotationVectorSubscription.cancel();

      return false;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StartSensorStreamFailure(error), stackTrace);
    }
  }


  ///Starts Stream of sensorData to pass to the Reader_repository
  Future<bool> stopSensorStream() async {
    try {
      if (kDebugMode) {
        print('reader_client -> stopSensorStream -> Entry');
      }

      await _sensorAccelerometerSubscription.cancel();
      await _sensorGyroscopeSubscription.cancel();
      await _sensorLinearAccelerationSubscription.cancel();
      await _sensorRotationVectorSubscription.cancel();

      final stopSensorStreamResult = await sensorMethodChannel.invokeMethod(
          "stopSensorStream").toString();

      return false;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StopSensorStreamFailure(error), stackTrace);
    }
  }
}
