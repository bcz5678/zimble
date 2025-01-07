import 'dart:async';
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
  var sensorLinearAccelerationChannel = NativeChannels().sensorLinearAccelerationStream;
  var sensorRotationVectorStreamChannel = NativeChannels().sensorRotationVectorStream;


  late BehaviorSubject<String> _sensorStream;
  late StreamSubscription<dynamic> _sensorChannelSubscription;


  /// Stream of [BluetoothReader] which will emit the current reader when
  /// the connection process changes
  //Stream<BluetoothReader> get bluetoothReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<NetworkReader> get networkReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<UsbReader> get usbReader;

  Stream<String> get sensorStream => _sensorStream;


  ///Starts Stream of sensorData to pass to the Reader_repository
  Future<bool> startSensorStream() async {
    try {
      if (kDebugMode) {
        print('reader_client -> startSensorStream -> Entry');
      }

      final startSensorStreamResult = await sensorMethodChannel.invokeMethod(
          "startSensorStream").toString();

      ///[ANCHOR]
      _sensorChannelSubscription =
        sensorAccelerometerStreamChannel
            .receiveBroadcastStream()
            .distinct()
            .listen((event) {
          if (kDebugMode) {
            print('reader_client -> startSensorStream -> EventChannelData -> ${event}');
          }
          _sensorStream.add(event.toString());
        }
      );
      return true;
    } on PlatformException catch (e) {

      if (kDebugMode) {
        print('reader_client -> startSensorStream -> Error: ${e.message}');
      }

      await _sensorChannelSubscription.cancel();

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

      await _sensorChannelSubscription.cancel();

      final stopSensorStreamResult = await sensorMethodChannel.invokeMethod(
          "stopSensorStream").toString();

      return false;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StopSensorStreamFailure(error), stackTrace);
    }
  }
}
