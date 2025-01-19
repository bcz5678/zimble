import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'readers_connect_event.dart';
part 'readers_connect_state.dart';

class ReadersConnectBloc extends Bloc<ReadersConnectEvent, ReadersConnectState> {
  ReadersConnectBloc({
    required ReaderRepository readerRepository,
  })
      : _readerRepository = readerRepository,
        super(const ReadersConnectState.initial()) {
    on<GetPairedBluetoothDevices> (onGetPairedBluetoothDevices);
    on<StartScanningBluetoothDevices> (onStartScanningBluetoothDevices);
    on<StopScanningBluetoothDevices> (onStopScanningBluetoothDevices);
    on<ConnectToBluetoothDevice> (onConnectToBluetoothDevice);
    on<DisconnectFromBluetoothDevice> (onDisconnectFromBluetoothDevice);

  }

  /// Initialize readerRepository and _bluetoothPairedReadersSubscription
  /// to handle changes to the bluetooth list
  final ReaderRepository _readerRepository;

  late StreamSubscription<List<Reader>> _currentlyAttachedReadersList;


  void onGetPairedBluetoothDevices(
      GetPairedBluetoothDevices event,
      Emitter<ReadersConnectState> emit,
      ) async {

    emit(state.copyWith(
        stateStatus: ReadersConnectStatus.pairedLoading,
    ));

    if (kDebugMode) {
      print('readers_connect_bluetooth_paired_bloc -> onGetPairedBluetoothDevices -> Entry');
    }

    final bluetoothPairedDevicesList = await _readerRepository.getPairedBluetoothDevices();

    if (kDebugMode) {
      print('readers_connect_bluetooth_paired_bloc -> onGetPairedBluetoothDevices -> bluetoothPairedReadersList - $bluetoothPairedDevicesList');
      print('readers_connect_bluetooth_paired_bloc -> onGetPairedBluetoothDevices -> bluetoothPairedReadersList.runtimeType - ${bluetoothPairedDevicesList.runtimeType}');
    }

    emit(state.copyWith(
      stateStatus: ReadersConnectStatus.pairedDone,
      bluetoothPairedDevicesList: bluetoothPairedDevicesList,
    ),
    );
  }

  Future<void> onStartScanningBluetoothDevices(
      StartScanningBluetoothDevices event,
      Emitter<ReadersConnectState> emit,
      ) async {

    emit(state.copyWith(
      stateStatus: ReadersConnectStatus.scannedLoading,
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
            stateStatus: ReadersConnectStatus.scannedBluetoothDevicesUpdated,
            bluetoothScannedDevicesList: bluetoothScannedDevicesList,
          );
        } catch (error, stackTrace){
          return state.copyWith(
            stateStatus: ReadersConnectStatus.scannedError,
          );
        }
      },
    );
    transformer: restartable();
  }

  Future<void> onStopScanningBluetoothDevices(
      StopScanningBluetoothDevices event,
      Emitter<ReadersConnectState> emit,
      ) async {

    final stopScanningBluetoothDevicesResult = await _readerRepository.stopScanningBluetoothDevices();

    emit(state.copyWith(
      stateStatus: ReadersConnectStatus.scannedDone,
    ),
    );

    if (kDebugMode) {
      print('readers_connect_bluetooth_scanned_bloc -> onStopScanBluetoothDevices -> Entry');
    }
  }

  void onConnectToBluetoothDevice(
      ConnectToBluetoothDevice event,
      Emitter<ReadersConnectState> emit,
      ) async {

    emit(state.copyWith(
      stateStatus: ReadersConnectStatus.connectionStatusInProgress,
      //bluetoothPairedDevicesList: state.bluetoothPairedDevicesList,
      selectedBluetoothDevice: event.device,

    ));

    final deviceConnectBluetoothResponse =
    await _readerRepository.connectToBluetoothDevice(event.device);

    if (deviceConnectBluetoothResponse == true) {
      emit(state.copyWith(
        stateStatus: ReadersConnectStatus.connectionStatusSuccess,
      ));
    } else {
      emit(state.copyWith(
        stateStatus: ReadersConnectStatus.connectionStatusFailed,
      ));
    }
  }

  void onDisconnectFromBluetoothDevice(
      DisconnectFromBluetoothDevice event,
      Emitter<ReadersConnectState> emit,
      ) async {

    emit(state.copyWith(
      stateStatus: ReadersConnectStatus.connectionStatusInProgress,
      selectedBluetoothDevice: event.device,
    ),
    );

    final deviceConnectBluetoothResponse =
    await _readerRepository.disconnectFromBluetoothDevice(event.device);

    if (kDebugMode) {
      print('readers_connect_bluetooth_scanned_bloc -> onDisconnectFromBluetoothDevice -> Response ${deviceConnectBluetoothResponse}');
    }

    if (deviceConnectBluetoothResponse == true) {
      emit(state.copyWith(
        stateStatus: ReadersConnectStatus.connectionStatusSuccess,
      ));
    } else {
      emit(state.copyWith(
        stateStatus: ReadersConnectStatus.connectionStatusFailed,
      ));
    }
  }
}
