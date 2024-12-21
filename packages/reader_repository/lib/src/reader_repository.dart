import 'dart:async';

import 'package:drift_storage/drift_storage.dart' as drift;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:reader_client/reader_client.dart';
import 'package:bluetooth_reader_client/bluetooth_reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:rxdart/rxdart.dart';

/// {@template reader_repository}
/// A base failure for the reader repository
/// {@endtemplate}
abstract class ReaderFailure with EquatableMixin implements Exception {
  const ReaderFailure(this.error);

  ///The error which was caught
  final Object error;

  @override
  List<Object> get props => [error];
}

/// Thrown when getPairedBluetoothDevice fails.
class GetPairedBluetoothDevicesFailure extends ReaderFailure {
  const GetPairedBluetoothDevicesFailure(super.error);
}

/// Thrown when startScanningBluetoothDevices fails.
class StartScanningBluetoothDevicesFailure extends ReaderFailure {
  const StartScanningBluetoothDevicesFailure(super.error);
}

/// Thrown when stopScanningBluetoothDevices fails.
class StopScanningBluetoothDevicesFailure extends ReaderFailure {
  const StopScanningBluetoothDevicesFailure(super.error);
}

/// Thrown when connectToBluetoothDevice fails.
class ConnectToBluetoothDeviceFailure extends ReaderFailure {
  const ConnectToBluetoothDeviceFailure(super.error);
}

/// Thrown when disconnectFromBluetoothDevice fails.
class DisconnectFromBluetoothDeviceFailure extends ReaderFailure {
  const DisconnectFromBluetoothDeviceFailure(super.error);
}


/// [TODO] Add failure definitions here for exception logging and handling


/// {@template reader_repository}
/// Reader Repository
/// {@endtemplate}
class ReaderRepository {
  /// {@macro reader_repository}
  ReaderRepository({
      required ReaderClient readerClient,
      required drift.AppDatabase storage,
  }) :  _readerClient = readerClient,
        _storage = storage;

  final ReaderClient _readerClient;
  final drift.AppDatabase _storage;

  final _bluetoothReaderClient = BluetoothReaderClient();
  final _usbReaderClient  = UsbReaderClient();
  final _networkReaderClient = NetworkReaderClient();

  /// Getter for current reader.
  /// [TODO] upgrade this to a multiple reader list

  Stream<List<Reader>> get bluetoothScannedReadersList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get bluetoothScannedReadersList -> Entry');
    }

    return _bluetoothReaderClient
        .bluetoothScannedReadersList
        .map((deviceList) {
      List<Reader> tempList = [];
      for (var device in deviceList) {
        tempList.add(
            Reader.fromBluetoothReader(bluetoothReader: device)
        );
      }
      return tempList;
    })
        .asBroadcastStream();
  }


  Stream<List<Reader>> get usbReadersList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get usbReadersList -> Entry');
    }

    return _bluetoothReaderClient
        .bluetoothScannedReadersList
        .map((deviceList) {
      List<Reader> tempList = [];
      for (var device in deviceList) {
        tempList.add(
            Reader.fromBluetoothReader(bluetoothReader: device)
        );
      }
      return tempList;
    })
        .asBroadcastStream();

  }

  Stream<List<Reader>> get networkReadersList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get networkReadersList -> Entry');
    }

    return _bluetoothReaderClient
        .bluetoothScannedReadersList
        .map((deviceList) {
      List<Reader> tempList = [];
      for (var device in deviceList) {
        tempList.add(
            Reader.fromBluetoothReader(bluetoothReader: device)
        );
      }
      return tempList;
    })
        .asBroadcastStream();
  }

  Stream<List<Reader>> get savedReadersList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get savedReadersList -> Entry');
    }

    return _bluetoothReaderClient
        .bluetoothScannedReadersList
        .map((deviceList) {
      List<Reader> tempList = [];
      for (var device in deviceList) {
        tempList.add(
            Reader.fromBluetoothReader(bluetoothReader: device)
        );
      }
      return tempList;
    })
        .asBroadcastStream();
  }



  Stream<List<Reader>> get currentlyAttachedReadersList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get currentlyAttachedReadersList -> Entry');
    }

    return _bluetoothReaderClient
        .bluetoothScannedReadersList
        .map((deviceList) {
      List<Reader> tempList = [];
      for (var device in deviceList) {
        tempList.add(
            Reader.fromBluetoothReader(bluetoothReader: device)
        );
      }
      return tempList;
    })
        .asBroadcastStream();
  }


  final BehaviorSubject<String> _placeholderData = BehaviorSubject.seeded(
      'null');

  /// Gets the currently paired bluetooth devices
  ///
  /// Throws a [getPairedBluetoothDevicesFailure] if an exception occurs.
  Future<List<Reader>> getPairedBluetoothDevices() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> getPairedBluetoothDevices -> Entry');
    }
    try {
      var deviceList = await _bluetoothReaderClient.getPairedBluetoothDevices();

      List<Reader> returnList = [];
      for (var device in deviceList) {
        returnList.add(
          Reader.fromBluetoothReader(bluetoothReader: device),
        );
      }
      return returnList;

    } on GetPairedBluetoothDevicesFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          GetPairedBluetoothDevicesFailure(error),
          stackTrace
      );
    }
  }


  /// Send the command to start scanning for Bluetooth devices to pair
  ///
  /// Throws a [startScanningBluetoothDevicesFailure] if an exception occurs.
  Future<String> startScanningBluetoothDevices() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> startScanningBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.startScanningBluetoothDevices();
    } on StartScanningBluetoothDevicesFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StartScanningBluetoothDevicesFailure(error),
          stackTrace
      );
    }
  }

  /// Send the command to stop scanning for Bluetooth devices
  ///
  /// Throws a [stopScanningBluetoothDevicesFailure] if an exception occurs.
  Future<String> stopScanningBluetoothDevices() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> stopScanningBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.stopScanningBluetoothDevices();
    } on StopScanningBluetoothDevicesFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StopScanningBluetoothDevicesFailure(error),
          stackTrace
      );
    }
  }

  /// Send the command to connect to a Bluetooth device
  ///
  /// Throws a [connectToBluetoothDeviceFailure] if an exception occurs.
  Future<BluetoothReader> connectToBluetoothDevice(bluetoothDevice) async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> connectToBluetoothDevices -> Entry');
    }
    try {
      return await _bluetoothReaderClient.connectToBluetoothDevice();
    } on ConnectToBluetoothDeviceFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          ConnectToBluetoothDeviceFailure(error),
          stackTrace
      );
    }
  }

  /// Send the command to disconnect from a Bluetooth device
  ///
  /// Throws a [disconnectFromBluetoothDeviceFailure] if an exception occurs.
  Future<BluetoothReader> disconnectFromBluetoothDevice(bluetoothDevice) async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> disconnectFromBluetoothDevice -> Entry');
    }
    try {
      return await _bluetoothReaderClient.disconnectFromBluetoothDevice();
    } on DisconnectFromBluetoothDeviceFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          DisconnectFromBluetoothDeviceFailure(error),
          stackTrace
      );
    }
  }
}
