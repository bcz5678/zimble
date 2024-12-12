import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reader_client/reader_client.dart';


/// Bluetooth implementation of reader_client
class BluetoothReaderClient implements ReaderClient {
  BluetoothReaderClient({

}) : ;


  /// Gets a list of Paired Bluetooth Readers
  @override
  Future<List<BluetoothReader>> getPairedBluetoothDevices() async {
    late List<BluetoothReader> bluetoothPairedDevicesList = [];
    try {
      if (kDebugMode) {
        print('bluetooth_reader_client -> getPairedBluetoothDevices -> Entry');
      }

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

    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DisconnectFromBluetoothDeviceFailure(error), stackTrace);
    }

  }
}
