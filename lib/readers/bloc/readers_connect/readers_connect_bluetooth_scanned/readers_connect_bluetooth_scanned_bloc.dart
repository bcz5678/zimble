import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'readers_connect_bluetooth_scanned_event.dart';
part 'readers_connect_bluetooth_scanned_state.dart';

class ReadersConnectBluetoothScannedBloc extends Bloc<ReadersConnectBluetoothScannedEvent, ReadersConnectBluetoothScannedState> {
  ReadersConnectBluetoothScannedBloc({
    required ReaderRepository readerRepository,
  }) : _readerRepository = readerRepository,
        super(const ReadersConnectBluetoothScannedState.initial()) {

    on<StartScanningBluetoothDevices> (onStartScanningBluetoothDevices);
    on<StopScanningBluetoothDevices> (onStopScanningBluetoothDevices);

  }

  /// Initialize readerRepository and _bluetoothScannedReadersSubscription
  /// to handle changes to the bluetooth list
  final ReaderRepository _readerRepository;

  Future<void> onStartScanningBluetoothDevices(
      StartScanningBluetoothDevices event,
      Emitter<ReadersConnectBluetoothScannedState> emit,
      ) async {

    emit(state.copyWith(
        stateStatus: ReadersConnectBluetoothScannedStatus.loading,
      ),
    );

    if (kDebugMode) {
      print('readers_connect_bluetooth_scanned_bloc -> onStartScanBluetoothDevices -> Entry');
    }

    final startScanningBluetoothDevicesResult = await _readerRepository.startScanningBluetoothDevices();

    await emit.forEach(
      _readerRepository.bluetoothScannedDevicesList,
      onData: (List<BluetoothDevice> bluetoothScannedDevicesList) {
        try {
          return state.copyWith(
            stateStatus: ReadersConnectBluetoothScannedStatus.scannedBluetoothDevicesUpdated,
            bluetoothScannedDevicesList: bluetoothScannedDevicesList,
          );
        } catch (error, stackTrace){
          return state.copyWith(
            stateStatus: ReadersConnectBluetoothScannedStatus.error,
          );
        }
      },
    );
    transformer: restartable();
  }

  Future<void> onStopScanningBluetoothDevices(
    StopScanningBluetoothDevices event,
    Emitter<ReadersConnectBluetoothScannedState> emit,
  ) async {

    final stopScanningBluetoothDevicesResult = await _readerRepository.stopScanningBluetoothDevices();
    final _bluetoothScannedDevicesList = await _readerRepository.bluetoothScannedDevicesList.last;

    emit(state.copyWith(
        stateStatus: ReadersConnectBluetoothScannedStatus.done,
        bluetoothScannedDevicesList: _bluetoothScannedDevicesList,
      ),
    );

    if (kDebugMode) {
      print('readers_connect_bluetooth_scanned_bloc -> onStopScanBluetoothDevices -> Entry');
    }
  }


  @override
  Future<void> close() async {
    super.close();
  }
}
