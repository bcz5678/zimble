import 'dart:async';

import 'package:bluetooth_reader_client/bluetooth_reader_client.dart';
import 'package:flutter/foundation.dart';
import 'package:network_reader_client/network_reader_client.dart';
import 'package:usb_reader_client/usb_reader_client.dart';
import 'package:reader_client/reader_client.dart';


/// Exceptions from the authentication client.
abstract class ReaderException implements Exception {
  const ReaderException(this.error);

  /// The error which was caught.
  final Object error;
}

/// Thrown during the get paired bluetooth devices process if a failure occurs.
class GetPairedBluetoothDevicesFailure extends ReaderException {
  const GetPairedBluetoothDevicesFailure(super.error);
}

/// Thrown during the start scanning bluetooth devices process if a failure occurs.
class StartScanningBluetoothDevicesFailure extends ReaderException {
  const StartScanningBluetoothDevicesFailure(super.error);
}

/// Thrown during the stop scanning bluetooth devices process if a failure occurs.
class StopScanningBluetoothDevicesFailure extends ReaderException {
  const StopScanningBluetoothDevicesFailure(super.error);
}

/// Thrown during the connect to bluetooth device process if a failure occurs.
class ConnectToBluetoothDeviceFailure extends ReaderException {
  const ConnectToBluetoothDeviceFailure(super.error);
}

/// Thrown during the disconnect from bluetooth device process if a failure occurs.
class DisconnectFromBluetoothDeviceFailure extends ReaderException {
  const DisconnectFromBluetoothDeviceFailure(super.error);
}


/// Reader client
class ReaderClient {
  const ReaderClient({
    required BluetoothReaderClient bluetoothReaderClient,
    required NetworkReaderClient networkReaderClient,
    required UsbReaderClient usbReaderClient,
  })
      : _bluetoothReaderClient = bluetoothReaderClient,
        _networkReaderClient = networkReaderClient,
        _usbReaderClient = usbReaderClient;

  final BluetoothReaderClient _bluetoothReaderClient;
  final NetworkReaderClient _networkReaderClient;
  final UsbReaderClient _usbReaderClient;


  /// Stream of [BluetoothReader] which will emit the current reader when
  /// the connection process changes
  //Stream<BluetoothReader> get bluetoothReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<NetworkReader> get networkReader;

  /// Stream of [NetworkReader] which will emit the current reader when
  /// the connection process changes
  //Stream<UsbReader> get usbReader;

  /// Gets a list of Paired Bluetooth Readers
  Future<List<BluetoothReader>> getPairedBluetoothDevices() async {
    if (kDebugMode) {
      print('reader_client -> getPairedBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.getPairedBluetoothDevices();
    } on GetPairedBluetoothDevicesFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          GetPairedBluetoothDevicesFailure(error), stackTrace);
    }
  }

    /// Sends the command to device to start scanning for bluetooth devices
  Future<String> startScanningBluetoothDevices() async {
    if (kDebugMode) {
      print('reader_client -> startScanningBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.startScanningBluetoothDevices();
    } on StartScanningBluetoothDevicesFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StartScanningBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to stop scanning for bluetooth devices
  Future<String> stopScanningBluetoothDevices() async {
    if (kDebugMode) {
      print('reader_client -> stopScanningBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.stopScanningBluetoothDevices();
    } on StopScanningBluetoothDevicesFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StopScanningBluetoothDevicesFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to connect to a specific bluetooth device
  Future<BluetoothReader> connectToBluetoothDevice() async {
    if (kDebugMode) {
      print('reader_client -> connectToBluetoothDevice -> Entry');
    }
    try {
      return await _bluetoothReaderClient.connectToBluetoothDevice();
    } on ConnectToBluetoothDeviceFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          ConnectToBluetoothDeviceFailure(error), stackTrace);
    }
  }

  /// Sends the command to device to disconnect from a specific bluetooth device
  Future<BluetoothReader> disconnectFromBluetoothDevice() async {
    if (kDebugMode) {
      print('reader_client -> disconnectFromBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.disconnectFromBluetoothDevice();
    } on DisconnectFromBluetoothDeviceFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          DisconnectFromBluetoothDeviceFailure(error), stackTrace);
    }
  }
}
