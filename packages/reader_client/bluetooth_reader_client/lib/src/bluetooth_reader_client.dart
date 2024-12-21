import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reader_client/reader_client.dart';
import 'package:native_channels_client/native_channels_client.dart';
import 'package:rxdart/rxdart.dart';


/// Bluetooth implementation of reader_client
class BluetoothReaderClient{
  BluetoothReaderClient();
  /*
  BluetoothReaderClient({
    required NativeChannelsClient nativeChannelClient,
}) :
  _nativeChannelsClient = nativeChannelClient;
   */

  //late NativeChannelsClient _nativeChannelsClient;


  Stream<List<BluetoothReader>> get bluetoothPairedReadersList => _bluetoothPairedReadersStream;
  Stream<List<BluetoothReader>> get bluetoothScannedReadersList => _bluetoothScannedReadersStream;

  //
  var btDevicesMethodChannel = const MethodChannel("mtg_rfid_method/reader/bt_devices");
  var btDevicesStreamChannel = const EventChannel('mtg_rfid_event/reader/bt_stream');

  late Stream<dynamic> _bluetoothScanningStreamSubscription;
  late List<BluetoothReader> _bluetoothScannedDevicesList = [];

  BehaviorSubject<List<BluetoothReader>> _bluetoothPairedReadersStream = BehaviorSubject<List<BluetoothReader>>();
  BehaviorSubject<List<BluetoothReader>> _bluetoothScannedReadersStream = BehaviorSubject<List<BluetoothReader>>();



  /// Gets a list of Paired Bluetooth Readers
  Future<List<BluetoothReader>> getPairedBluetoothDevices() async {
    late List<BluetoothReader> bluetoothPairedDevicesList = [];
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> Entry');
      }

      //Invoke method with top-level Return type ONLY to satisfy the StandardModelCodec return type of List<Object?>
      //Cannot ask for <List<Map<String, dynamic>>> as it will return error
      final bluetoothDevicesTemp = await btDevicesMethodChannel.invokeMethod<List>(
          "getPairedBluetoothDevices");

      if (kDebugMode) {
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> in service return from BT method handler');
      }

      bluetoothPairedDevicesList.clear();

      if (kDebugMode) {
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> bluetoothDevicesTemp - $bluetoothDevicesTemp');
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> bluetoothDevicesTemp.runtimetype - ${bluetoothDevicesTemp.runtimeType}');
      }

      // Casting the Returned List<Object?> to the BluetoothDeviceModel which extends the BluetoothDeviceEntity
      // Members returned as _Map<Object?, Object?> are actually Map<dynamic, dynamic>
      // Casting known API key:value pairs to the BluetoothDeviceModel with typecasting
      for (var device in bluetoothDevicesTemp!){
        bluetoothPairedDevicesList.add(
            BluetoothReader(
                name: device?["name"] as String?,
                macAddress: device["address"] as String,
                connectionStatus: device["connectionStatus"] as String?,
                readerDetails: device["readerDetails"] as Map<String, dynamic>? // as Map<String, dynamic>,
            )
        );
      }

      if (kDebugMode) {
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> $bluetoothPairedDevicesList');
      }

      return bluetoothPairedDevicesList;

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPairedBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to start scanning for bluetooth devices
  Future<String> startScanningBluetoothDevices() async {
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> startScanningBluetoothDevices -> Entry');
      }

      //Invoke method with top-level Return type ONLY to satisfy the StandardModelCodec return type of List<Object?>
      //Cannot ask for <List<Map<String, dynamic>>> as it will return error
      final startScanningBluetoothDevicesResult = await btDevicesMethodChannel.invokeMethod("startScanningBluetoothDevices").toString();

      if (kDebugMode) {
        print('bluetooth_reader_client -> startScanningBluetoothDevices -> Result: $startScanningBluetoothDevicesResult');
      }

      if (startScanningBluetoothDevicesResult == 'started') {
        _bluetoothScanningStreamSubscription =
            btDevicesStreamChannel
                .receiveBroadcastStream()
                .distinct()
                .map((event) {
              _bluetoothScannedDevicesList.clear();

              var _deviceList = scannedStreamEventToList(event.toString());

              _deviceList.forEach((_deviceObject) {
                _bluetoothScannedDevicesList.add(
                    BluetoothReader(
                      name: _deviceObject["name"] as String,
                      macAddress: _deviceObject["address"] as String,
                    )
                );
              });
            });

        _bluetoothScannedReadersStream.add(_bluetoothScannedDevicesList.reversed.toSet().toList());
      }

      return startScanningBluetoothDevicesResult;

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StartScanningBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to stop scanning for bluetooth devices
  Future<String> stopScanningBluetoothDevices() async {
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> stopScanningBluetoothDevices -> Entry');
      }

      final stopScanningBluetoothDevicesResult =
        await btDevicesMethodChannel.invokeMethod("stopScanningBluetoothDevices");

      return stopScanningBluetoothDevicesResult.toString();

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StopScanningBluetoothDevicesFailure(error), stackTrace);
    }

  }

  /// Sends the command to device to connect to a specific bluetooth
  Future<BluetoothReader> connectToBluetoothDevice() async {
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> connectToBluetoothDevice -> Entry');
      }

      /// [TODO]
      return BluetoothReader();

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ConnectToBluetoothDeviceFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to disconnect from a specific bluetooth device
  Future<BluetoothReader> disconnectFromBluetoothDevice() async {
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> disconnectFromBluetoothDevice -> Entry');
      }

      /// [TODO]
      return BluetoothReader();

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DisconnectFromBluetoothDeviceFailure(error), stackTrace);
    }

  }

  List<dynamic> scannedStreamEventToList(String event) {
    final streamResult = event;
    late List<dynamic> _deviceListToReturn = [];

    //Clean/Split stream string into a list of devices
    List<String> tempList = streamResult
        .replaceAll('[{', '')
        .replaceAll('}]', '')
        .replaceAll('=', ': ')
        .split('}, {');

    // Formatting the Returned Stream String Devices to the BluetoothDeviceModel which extends the BluetoothDeviceEntity
    // Casting known API key:value pairs to the BluetoothDeviceModel with typecasting
    for (var device in tempList){
      late String tempDevice = device
          .replaceAll('name', r'"name"')
          .replaceAll('address', r'"address"')
          .replaceAll('": ', r'": "')
          .replaceAll(', "', r'", "');

      tempDevice = "{$tempDevice\"}";

      var _deviceObject = json.decode(tempDevice);

      if(_deviceObject["name"] != "null") {
        _deviceListToReturn.add(_deviceObject);
      }
    }

    return _deviceListToReturn;
  }

}


