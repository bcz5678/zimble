import 'dart:async';

import 'package:flutter/foundation.dart';
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

  Stream<List<SensorData>> get sensorStream => _bluetoothPairedDevicesStream;

  var sensorMethodChannel = NativeChannels().sensorMethod;
  var sensorStreamChannel = NativeChannels().bluetoothEventStream;

  late Stream<dynamic> _sensorStreamSubscription;
  BehaviorSubject<
      List<SensorData>> _bluetoothPairedDevicesStream = BehaviorSubject<List<SensorData>>();


  /// Stream of [BluetoothReader] which will emit the current reader when
  /// the connection process changes
  //Stream<BluetoothReader> get bluetoothReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<NetworkReader> get networkReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<UsbReader> get usbReader;


  ///Starts Stream of sensorData to pass to the Reader_repository
  Future<String> startSensorStream() async {
    try {
      if (kDebugMode) {
        print('reader_client -> startSensorStream -> Entry');
      }

      final startSensorStreamResult = await sensorMethodChannel.invokeMethod(
          "startSensorStream").toString();

      if (kDebugMode) {
        print(
            'reader_client -> startSensorStream -> Result: $startSensorStreamResult');
      }

      if (startSensorStreamResult == 'started') {
        _sensorStreamSubscription =
            sensorStreamChannel
                .receiveBroadcastStream()
                .distinct()
                .map((event) {

              ///ANCHOR - PICK UP HERE
              ///[TODO] return sensordata
              if (kDebugMode) {
                print(
                    'reader_client -> startSensorStream -> Result: $startSensorStreamResult');
              }
            });
      }

      return startSensorStreamResult;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StartSensorStreamFailure(error), stackTrace);
    }
  }

  ///Starts Stream of sensorData to pass to the Reader_repository
  Future<String> stopSensorStream() async {
    try {
      if (kDebugMode) {
        print('reader_client -> stopSensorStream -> Entry');
      }

      final stopSensorStreamResult = await sensorMethodChannel.invokeMethod(
          "stopSensorStream").toString();

      if (kDebugMode) {
        print(
            'reader_client -> startSensorStream -> Result: $stopSensorStreamResult');
      }


      if (stopSensorStreamResult == 'started') {
        _sensorStreamSubscription =
            sensorStreamChannel
                .receiveBroadcastStream()
                .distinct()
                .map((event) {

              ///ANCHOR - PICK UP HERE
              ///[TODO] return sensordata
              if (kDebugMode) {
                print(
                    'reader_client -> startSensorStream -> Result: $stopSensorStreamResult');
              }
            });
      }

      return stopSensorStreamResult;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StopSensorStreamFailure(error), stackTrace);
    }
  }
}
