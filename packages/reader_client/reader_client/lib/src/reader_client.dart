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

}
