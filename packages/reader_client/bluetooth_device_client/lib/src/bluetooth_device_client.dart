import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reader_client/reader_client.dart';
import 'package:native_channels_client/native_channels_client.dart';
import 'package:rxdart/rxdart.dart';

/// Exceptions from the authentication client.
abstract class BluetoothClientException implements Exception {
  const BluetoothClientException(this.error);

  /// The error which was caught.
  final Object error;
}

/// Thrown after failure to getPairedBluetoothDevices from the device client
class GetPairedBluetoothDevicesFailure extends BluetoothClientException {
  const GetPairedBluetoothDevicesFailure(super.error);
}

/// Thrown after failure to start scanning for bluetooth devies from the device client
class StartScanningBluetoothDevicesFailure extends BluetoothClientException {
  const StartScanningBluetoothDevicesFailure(super.error);
}

/// Thrown after failure to stop scanning for bluetooth devices from the device client
class StopScanningBluetoothDevicesFailure extends BluetoothClientException {
  const StopScanningBluetoothDevicesFailure(super.error);
}

/// Thrown after failure to connect to a Bluetooth Device
class ConnectToBluetoothDeviceFailure extends BluetoothClientException {
  const ConnectToBluetoothDeviceFailure(super.error);
}

/// Thrown after failure to disconnect from a Bluetooth Device
class DisconnectFromBluetoothDeviceFailure extends BluetoothClientException {
  const DisconnectFromBluetoothDeviceFailure(super.error);
}


/// Bluetooth implementation of Device_client
class BluetoothDeviceClient {
  BluetoothDeviceClient();

  /*
  BluetoothDeviceClient({
    required NativeChannelsClient nativeChannelClient,
}) :
  _nativeChannelsClient = nativeChannelClient;
   */

  //late NativeChannelsClient _nativeChannelsClient;


  Stream<List<BluetoothDevice>> get bluetoothPairedDevicesList =>
      _bluetoothPairedDevicesStream;

  Stream<List<BluetoothDevice>> get bluetoothScannedDevicesList =>
      _bluetoothScannedDevicesStream.asBroadcastStream();

  //
  var btDevicesMethodChannel = NativeChannels().bluetoothMethod;
  var btDevicesStreamChannel = NativeChannels().bluetoothEventStream;

  late StreamSubscription<dynamic> _bluetoothScanningStreamSubscription;
  late List<BluetoothDevice> _bluetoothScannedDevicesList = [];

  BehaviorSubject<
      List<BluetoothDevice>> _bluetoothPairedDevicesStream = BehaviorSubject<
      List<BluetoothDevice>>();
  BehaviorSubject<
      List<BluetoothDevice>> _bluetoothScannedDevicesStream = BehaviorSubject<
      List<BluetoothDevice>>();


  /// Gets a list of Paired Bluetooth Devices
  Future<List<BluetoothDevice>> getPairedBluetoothDevices() async {
    late List<BluetoothDevice> bluetoothPairedDevicesList = [];
    try {
      if (kDebugMode) {
        print('bluetooth_device_client -> getPairedBluetoothDevices -> Entry');
      }

      //Invoke method with top-level Return type ONLY to satisfy the StandardModelCodec return type of List<Object?>
      //Cannot ask for <List<Map<String, dynamic>>> as it will return error
      final bluetoothDevicesTemp = await btDevicesMethodChannel.invokeMethod<
          List>(
          "getPairedBluetoothDevices");

      if (kDebugMode) {
        print(
            'bluetooth_device_client -> getPairedBluetoothDevices -> in service return from BT method handler');
      }

      bluetoothPairedDevicesList.clear();

      if (kDebugMode) {
        print(
            'bluetooth_device_client -> getPairedBluetoothDevices -> bluetoothDevicesTemp - $bluetoothDevicesTemp');
        print(
            'bluetooth_device_client -> getPairedBluetoothDevices -> bluetoothDevicesTemp.runtimetype - ${bluetoothDevicesTemp
                .runtimeType}');
      }

      // Casting the Returned List<Object?> to the BluetoothDevice
      // Members returned as _Map<Object?, Object?> are actually Map<dynamic, dynamic>
      // Casting known API key:value pairs to the BluetoothDeviceModel with typecasting
      for (var device in bluetoothDevicesTemp!) {
        bluetoothPairedDevicesList.add(
            BluetoothDevice(
              name: device?["name"] as String?,
              macAddress: device["address"] as String,
              connectionStatus: device["connectionStatus"] as bool?,
            )
        );
      }

      if (kDebugMode) {
        print(
            'bluetooth_device_client -> getPairedBluetoothDevices -> $bluetoothPairedDevicesList');
      }

      return bluetoothPairedDevicesList;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          GetPairedBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to start scanning for bluetooth devices
  Future<String> startScanningBluetoothDevices() async {
    try {
      if (kDebugMode) {
        print(
            'bluetooth_device_client -> startScanningBluetoothDevices -> Entry');
      }

      //Invoke method with top-level Return type ONLY to satisfy the StandardModelCodec return type of List<Object?>
      //Cannot ask for <List<Map<String, dynamic>>> as it will return error
      final startScanningBluetoothDevicesResult = await btDevicesMethodChannel
          .invokeMethod("startScanningBluetoothDevices").toString();

      if (kDebugMode) {
        print(
            'bluetooth_device_client -> startScanningBluetoothDevices -> Result: $startScanningBluetoothDevicesResult');
      }
      _bluetoothScanningStreamSubscription =
          btDevicesStreamChannel
              .receiveBroadcastStream()
              .distinct()
              .listen((event) {
            _bluetoothScannedDevicesList.clear();

            var devicesList = event.toString().substring(1, event.toString().length - 1).replaceAll('}, {', '}++SPLIT++{').split('++SPLIT++');

            for (final deviceObject in devicesList) {
              final tempObject = json.decode(deviceObject) as Map<String, dynamic>;

              _bluetoothScannedDevicesList.add(
                  BluetoothDevice(
                    macAddress: tempObject['address'] as String,
                    name: tempObject['name'] !=null ? tempObject['name'] as String : "null" as String,
                  ),
              );
            };

            _bluetoothScannedDevicesStream.add(_bluetoothScannedDevicesList.reversed.toSet().toList());
          });

      return startScanningBluetoothDevicesResult;

    }  on PlatformException catch (e) {

      // Native side returns error on start
      await _bluetoothScanningStreamSubscription.cancel();
      return e.toString();

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StartScanningBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to stop scanning for bluetooth devices
  Future<String> stopScanningBluetoothDevices() async {
    try {
      if (kDebugMode) {
        print(
            'bluetooth_device_client -> stopScanningBluetoothDevices -> Entry');
      }

      final stopScanningBluetoothDevicesResult =
      await btDevicesMethodChannel.invokeMethod("stopScanningBluetoothDevices");
      if (kDebugMode) {
        print(
            'bluetooth_device_client -> stopScanningBluetoothDevices -> ${stopScanningBluetoothDevicesResult}');
      }

      await _bluetoothScanningStreamSubscription.cancel();

      if (kDebugMode) {
        print(
            'bluetooth_device_client -> stopScanningBluetoothDevices -> subscriptionCancelled');
      }

      return stopScanningBluetoothDevicesResult.toString();

    }  on PlatformException catch (e) {
      // Native side returns error on start
      await _bluetoothScanningStreamSubscription.cancel();
      return e.toString();

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StopScanningBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to connect to a specific bluetooth
  Future<BluetoothReader> connectToBluetoothDevice(
      BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        print('bluetooth_Device_client -> connectToBluetoothDevice -> Entry');
      }

      //format data to pass through method channel
      var data = MethodChannelData(device.toJson()).encodeSendMap();

      final  connectToBluetoothDeviceResultMap = await btDevicesMethodChannel.invokeMapMethod('connectToBluetoothDevice', data);

      //Parse messageData is messageSuccess is true
      if (connectToBluetoothDeviceResultMap?["messageSuccess"] == "true") {

        //parse messageData JSON
        var jsonMessageData = json.decode(connectToBluetoothDeviceResultMap!["messageData"].toString()) as Map<String, dynamic>;

        //Build BluetoothDeviceModel if returned correctly
        if( jsonMessageData.containsKey("bluetoothDeviceEntity")) {

          var connectionUpdateBluetoothDeviceResult = BluetoothReader.fromMessageData(jsonMessageData);
          return connectionUpdateBluetoothDeviceResult;
        } else {
          throw Exception("bluetoothDeviceEntity not found");
        }
      } else if (connectToBluetoothDeviceResultMap?["messageSuccess"] == "false") {
        throw Exception("messageSend Fail");
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          ConnectToBluetoothDeviceFailure(error), stackTrace);
    }
    return Future.error("Unknown error");
  }

  /// Sends the command to device to disconnect from a specific bluetooth device
  Future<BluetoothDevice> disconnectFromBluetoothDevice(BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        print(
            'bluetooth_Device_client -> disconnectFromBluetoothDevice -> Entry');
      }

      //format data to pass through method channel
      var data = MethodChannelData(device.toJson()).encodeSendMap();

      final  disconnectFromBluetoothDeviceResultMap = await btDevicesMethodChannel.invokeMapMethod('disconnectFromBluetoothDevice', data);

      //Parse messageData is messageSuccess is true
      if (disconnectFromBluetoothDeviceResultMap?["messageSuccess"] == "true") {

        //parse messageData JSON
        var jsonMessageData = json.decode(disconnectFromBluetoothDeviceResultMap!["messageData"].toString()) as Map<String, dynamic>;

        if (kDebugMode) {
          print(
              'bluetooth_Device_client -> disconnectFromBluetoothDevice -> jsonMessageData - ${jsonMessageData}');
        }

        //Build BluetoothDeviceModel if returned correctly
        if( jsonMessageData.containsKey("bluetoothDeviceEntity")) {

          var connectionUpdateBluetoothDeviceResult = BluetoothDevice.fromMessageData(jsonMessageData);
          return connectionUpdateBluetoothDeviceResult;
        } else {
          throw Exception("bluetoothDeviceEntity not found");
        }
      } else if (disconnectFromBluetoothDeviceResultMap ?["messageSuccess"] == "false") {
        throw Exception("messageSend Fail");
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          ConnectToBluetoothDeviceFailure(error), stackTrace);
    }
    return Future.error("Unknown error");
  }
}




