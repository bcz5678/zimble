import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reader_client/reader_client.dart';
import 'package:native_channels_client/native_channels_client.dart';


/// Bluetooth implementation of reader_client
class BluetoothReaderClient implements ReaderClient {
  BluetoothReaderClient({
    required NativeChannelsClient nativeChannelClient,
}) :
  _nativeChannelsClient = nativeChannelClient;

  late NativeChannelsClient _nativeChannelsClient;

  var btDevicesStreamChannel = const EventChannel('mtg_rfid_event/reader/bt_stream');
  var btDevicesMethodChannel = const MethodChannel("mtg_rfid_method/reader/bt_devices");

  /// Gets a list of Paired Bluetooth Readers
  @override
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
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> $bluetoothDevicesTemp');
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> ${bluetoothDevicesTemp.runtimeType}');
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
  @override
  Future<String> startScanningBluetoothDevices() async {
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> startScanningBluetoothDevices -> Entry');
      }

      /// [TODO]
      return 'TBD';

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StartScanningBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to stop scanning for bluetooth devices
  @override
  Future<String> stopScanningBluetoothDevices() async {
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> stopScanningBluetoothDevices -> Entry');
      }

      /// [TODO]
      return 'TBD';

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StopScanningBluetoothDevicesFailure(error), stackTrace);
    }

  }

  /// Sends the command to device to connect to a specific bluetooth
  @override
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
  @override
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

}
