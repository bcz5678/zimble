import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:native_channels_client/native_channels_client.dart';
import 'package:rxdart/rxdart.dart';


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

  var sensorMethodChannel = NativeChannels().bluetoothMethod;
  var sensorStreamChannel = NativeChannels().bluetoothEventStream;

  late Stream<dynamic> _sensorStreamSubscription;
  BehaviorSubject<List<SensorData>> _bluetoothPairedDevicesStream = BehaviorSubject<List<SensorData>>();



/// Stream of [BluetoothReader] which will emit the current reader when
  /// the connection process changes
  //Stream<BluetoothReader> get bluetoothReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<NetworkReader> get networkReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<UsbReader> get usbReader;

  Future<String> startSensorStream() async {
   try{

     if (kDebugMode) {
       print('reader_client -> startSensorStream -> Entry');
     }

     final startSensorStreamResult = await sensorMethodChannel.invokeMethod("startSensorStream").toString();

     if (kDebugMode) {
       print('reader_client -> startSensorStream -> Result: $startSensorStreamResult');
     }

     if(startSensorStreamResult == 'started') {
       _sensorStreamSubscription =
           sensorStreamChannel
               .receiveBroadcastStream()
               .distinct()
               .map((event) {


                 ///ANCHOR - PICK UP HERE
               }
     }

   } catch (error, stackTrace) {
     Error.throwWithStackTrace(StartSensorStreamFailure(error), stackTrace);
    }
  }
}
