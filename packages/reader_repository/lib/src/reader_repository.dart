import 'dart:async';

import 'package:bluetooth_device_client/bluetooth_device_client.dart';
import 'package:drift_storage/drift_storage.dart' as drift;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:network_device_client/network_device_client.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:usb_device_client/usb_device_client.dart';

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

/// Thrown when addConnectedReader fails.
class AddConnectedReaderFailure extends ReaderFailure {
  const AddConnectedReaderFailure(super.error);
}

/// Thrown when removeConnectedReader fails.
class RemoveConnectedReaderFailure extends ReaderFailure {
  const RemoveConnectedReaderFailure(super.error);
}

/// Thrown when disconnectFromBluetoothDevice fails.
class DisconnectFromBluetoothDeviceFailure extends ReaderFailure {
  const DisconnectFromBluetoothDeviceFailure(super.error);
}

/// Thrown when disconnectFromBluetoothDevice fails.
class StartSensorStreamFailure extends ReaderFailure {
  const StartSensorStreamFailure(super.error);
}

/// Thrown when disconnectFromBluetoothDevice fails.
class StopSensorStreamFailure extends ReaderFailure {
  const StopSensorStreamFailure(super.error);
}

/// Thrown when disconnectFromBluetoothDevice fails.
class StartTagScanStreamFailure extends ReaderFailure {
  const StartTagScanStreamFailure(super.error);
}

/// Thrown when disconnectFromBluetoothDevice fails.
class StopTagScanStreamFailure extends ReaderFailure {
  const StopTagScanStreamFailure(super.error);
}


/// [TODO] Add failure definitions here for exception logging and handling


/// Reader Repository
///
/// NOTE: We will be making a distinction between "Reader" and "Device"
///
/// Reader: Connected TSL Reader/Scanner, connected with the AsciiCOmmander Protocol
///         Readers can be Bluetooth, USB, or Network connected
///
/// Device: Device is a device that is detected but not connected
/// or already verified on a network.
/// This includes paired bluetooth, usb, and network devices.  ONce the
///
class ReaderRepository {
  /// {@macro reader_repository}
  ReaderRepository({
      required ReaderClient readerClient,
      required drift.AppDatabase storage,
  }) :  _readerClient = readerClient,
        _storage = storage;

  final ReaderClient _readerClient;
  final drift.AppDatabase _storage;

  final _bluetoothDeviceClient = BluetoothDeviceClient();
  final _usbDeviceClient  = UsbDeviceClient();
  final _networkDeviceClient = NetworkDeviceClient();

  final _currentlyAttachedReadersListController = BehaviorSubject<List<Reader>>.seeded([]);
  final _sensorStreamsController = BehaviorSubject<List<SensorData>>.seeded([]);
  final _bluetoothScannedDevicesListController = BehaviorSubject<List<BluetoothDevice>>.seeded([]);


  BehaviorSubject<List<Reader>> get currentlyAttachedReadersList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get currentlyAttachedReadersList -> Entry');
    }
      return _currentlyAttachedReadersListController;
  }


  /// Getter for current reader.
  /// [TODO] upgrade this to a multiple reader list

  Stream<List<BluetoothDevice>> get bluetoothPairedDevicesList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get bluetoothPairedDevicesList -> Entry');
    }

    return _bluetoothDeviceClient
        .bluetoothPairedDevicesList
        .asBroadcastStream();
    /*
    return _bluetoothDeviceClient
        .bluetoothScannedDevicesList
        .map((deviceList) {
      List<BluetoothDevice> tempList = [];
      for (var device in deviceList) {
        tempList.add(
            BluetoothDevice(device)
        );
      }
      return tempList;
    })
        .asBroadcastStream();
     */
  }

  /// Getter for current reader.
  /// [TODO] upgrade this to a multiple reader list

  Stream<List<BluetoothDevice>> get bluetoothScannedDevicesList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get bluetoothScannedDevicesList -> Entry');
    }

    return _bluetoothDeviceClient.bluetoothScannedDevicesList;
  }


  Stream<List<UsbDevice>> get usbDevicesList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get usbDevicesList -> Entry');
    }

    //Placeholder
    return BehaviorSubject<List<UsbDevice>>.seeded([UsbDevice()]);
  }

  Stream<List<NetworkDevice>> get networkDevicesList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get networkDevicesList -> Entry');
    }

    //Placeholder
    return BehaviorSubject<List<NetworkDevice>>.seeded([NetworkDevice()]);
  }

  Stream<List<GenericDevice>> get savedDevicesList {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get savedReadersList -> Entry');
    }

    //Placeholder
    return BehaviorSubject<List<GenericDevice>>.seeded([GenericDevice()]);
  }


  //
  Stream<SensorData> get sensorDataStreamAll  {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> get sensorDataStream -> Entry');
    }


    return _readerClient.streamSensorDataAll;
  }


  final BehaviorSubject<String> _placeholderData = BehaviorSubject.seeded(
      'null');

  /// Gets the currently paired bluetooth devices
  ///
  /// Throws a [getPairedBluetoothDevicesFailure] if an exception occurs.
  Future<List<BluetoothDevice>> getPairedBluetoothDevices() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> getPairedBluetoothDevices -> Entry');
    }
    try {

       final returnList = await _bluetoothDeviceClient.getPairedBluetoothDevices();

      if (kDebugMode) {
        print('reader_repository -> getPairedBluetoothDevices -> returnList - $returnList');
        print('reader_repository -> getPairedBluetoothDevices -> returnList.runtimetype - ${returnList.runtimeType}');
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
      return await _bluetoothDeviceClient.startScanningBluetoothDevices();
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
      return await _bluetoothDeviceClient.stopScanningBluetoothDevices();
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
  Future<bool> connectToBluetoothDevice(BluetoothDevice bluetoothDevice) async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> connectToBluetoothDevices -> Entry');
    }
    try {
      final bluetoothDeviceToReturn =
        await _bluetoothDeviceClient.connectToBluetoothDevice(bluetoothDevice);

      if (kDebugMode) {
        print(
            'reader_repository -> connectToBluetoothDevice -> bluetoothDeviceToReturn - $bluetoothDeviceToReturn');
      }

      if(bluetoothDeviceToReturn.macAddress != null
        && bluetoothDeviceToReturn.connectionStatus == true) {

        var newlyConnectedReader = Reader.fromBluetoothReader(
          bluetoothReader: bluetoothDeviceToReturn,
        );

        addConnectedReader(newlyConnectedReader);

        return true;

      } else {

        return false;
      }
    } on ConnectToBluetoothDeviceFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          ConnectToBluetoothDeviceFailure(error),
          stackTrace,
      );
    }
  }

  /// Send the command to disconnect from a Bluetooth device
  ///
  /// Throws a [disconnectFromBluetoothDeviceFailure] if an exception occurs.
  Future<BluetoothDevice> disconnectFromBluetoothDevice(BluetoothDevice bluetoothDevice) async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> disconnectFromBluetoothDevice -> Entry');
    }
    try {

      final disconnectFromBluetoothReaderResult = await _bluetoothDeviceClient.disconnectFromBluetoothDevice(bluetoothDevice);

      if (kDebugMode) {
        print('reader_repository -> disconnectFromBluetoothDevice -> ${disconnectFromBluetoothReaderResult}');
      }

      if(disconnectFromBluetoothReaderResult.connectionStatus == null) {
        removeConnectedReader(bluetoothDevice);
      }

      return disconnectFromBluetoothReaderResult;

    } on DisconnectFromBluetoothDeviceFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          DisconnectFromBluetoothDeviceFailure(error),
          stackTrace
      );
    }
  }

  /// Adds any newly connected Reader to the
  /// _currentlyAttachedReaders Stream for the getter
  void addConnectedReader(Reader reader) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> addConnectedReader -> Entry');
    }

    try {
      final newCurrentlyAttachedReadersList =
      List<Reader>
          .from(_currentlyAttachedReadersListController.value)
        ..add(reader);

      _currentlyAttachedReadersListController
          .add(newCurrentlyAttachedReadersList);

    } on AddConnectedReaderFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          AddConnectedReaderFailure(error),
          stackTrace,
      );
    }
  }

  /// Removes Disconnected Reader from the
  /// _currentlyAttachedReaders Stream for the getter
  void removeConnectedReader(BluetoothDevice device) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> removeConnectedReader -> Entry');
    }

    try {
      var tempcurrentlyAttachedReadersList = List<Reader>.from(_currentlyAttachedReadersListController.value);
      late List<Reader> newcurrentlyAttachedReadersList = [];

      if(kDebugMode) {
        print('reader_repository -> removeConnectedReader -> tempcurrentlyAttachedReadersList - ${tempcurrentlyAttachedReadersList}');
        print('reader_repository -> removeConnectedReader -> tempcurrentlyAttachedReadersList - ${tempcurrentlyAttachedReadersList.length}');
      }

      if (tempcurrentlyAttachedReadersList.isNotEmpty) {
        for (final reader in tempcurrentlyAttachedReadersList) {
          if (device.macAddress != reader.macAddress) {
            newcurrentlyAttachedReadersList.add(reader);
          }
        }

        if (kDebugMode) {
          print('reader_repository -> removeConnectedReader -> newcurrentlyAttachedReadersList - ${newcurrentlyAttachedReadersList}');
        }

        _currentlyAttachedReadersListController
            .add(newcurrentlyAttachedReadersList);
      }

    } on RemoveConnectedReaderFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AddConnectedReaderFailure(error),
        stackTrace,
      );
    }
  }


  /// Send command to start Sensor Streams and set stream subscription
  ///
  /// Throws a [StartSensorStreamFailure] if an exception occurs.
  Future<bool> startSensorStreams() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> startSensorStreams -> Entry');
    }
    try {
      return await _readerClient.startSensorStream();
    } on StartSensorStreamFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StartSensorStreamFailure(error),
          stackTrace
      );
    }
  }

  /// Send command to stop Sensor Streams
  ///
  /// Throws a [StopSensorStreamFailure] if an exception occurs.
  Future<bool> stopSensorStreams() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> stopSensorStreams -> Entry');
    }
    try {
      return await _readerClient.stopSensorStream();
    } on StopSensorStreamFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StopSensorStreamFailure(error),
          stackTrace
      );
    }
  }

  /// Send command start TagScan Stream and set stream subscription
  ///
  /// Throws a [StartTagScanStreamFailure] if an exception occurs.
  Future<bool> startTagScanStream() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> startTagScanStream -> Entry');
    }
    try {
      return await _readerClient.startTagScanStream();
    } on StartTagScanStreamFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StartTagScanStreamFailure(error),
          stackTrace
      );
    }
  }

  /// Send command stop TagScan Stream
  ///
  /// Throws a [StopTagScanStreamFailure] if an exception occurs.
  Future<bool> stopTagScanStream() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('reader_repository -> stopTagScanStream -> Entry');
    }
    try {
      return await _readerClient.stopTagScanStream();
    } on StopTagScanStreamFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          StopTagScanStreamFailure(error),
          stackTrace
      );
    }
  }

}
