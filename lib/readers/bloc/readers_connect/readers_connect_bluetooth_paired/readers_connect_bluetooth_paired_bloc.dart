import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_connect_bluetooth_paired_event.dart';
part 'readers_connect_bluetooth_paired_state.dart';

class ReadersConnectBluetoothPairedBloc extends Bloc<ReadersConnectBluetoothPairedEvent, ReadersConnectBluetoothPairedState> {
  ReadersConnectBluetoothPairedBloc({
    required ReaderRepository readerRepository,
  })
      : _readerRepository = readerRepository,
        super(const ReadersConnectBluetoothPairedState.initial()) {
      on<GetPairedBluetoothDevices> (onGetPairedBluetoothDevices);
      on<ConnectToBluetoothDevice> (onConnectToBluetoothDevice);
  }

  /// Initialize readerRepository and _bluetoothPairedReadersSubscription
  /// to handle changes to the bluetooth list
  final ReaderRepository _readerRepository;

  late StreamSubscription<List<Reader>> _currentlyConnectedReadersList;


  void onGetPairedBluetoothDevices(
    GetPairedBluetoothDevices event,
    Emitter<ReadersConnectBluetoothPairedState> emit,
    ) async {

      emit(state.copyWith(
          stateStatus: ReadersConnectBluetoothPairedStatus.loading,
        ),
      );

      if (kDebugMode) {
        print('readers_connect_bluetooth_paired_bloc -> onGetPairedBluetoothDevices -> Entry');
      }

      final bluetoothPairedDevicesList = await _readerRepository.getPairedBluetoothDevices();

      if (kDebugMode) {
        print('readers_connect_bluetooth_paired_bloc -> onGetPairedBluetoothDevices -> bluetoothPairedReadersList - $bluetoothPairedDevicesList');
        print('readers_connect_bluetooth_paired_bloc -> onGetPairedBluetoothDevices -> bluetoothPairedReadersList.runtimeType - ${bluetoothPairedDevicesList.runtimeType}');
      }

      emit(state.copyWith(
          stateStatus: ReadersConnectBluetoothPairedStatus.done,
          bluetoothPairedDevicesList: bluetoothPairedDevicesList,
        ),
      );
  }

  void onConnectToBluetoothDevice(
    ConnectToBluetoothDevice event,
    Emitter<ReadersConnectBluetoothPairedState> emit,
    ) async {

    emit(state.copyWith(
        stateStatus: ReadersConnectBluetoothPairedStatus.connectToDeviceStatusLoading,
        selectedBluetoothDevice: event.device,
      ),
    );

    final deviceConnectBluetoothResponse =
      await _readerRepository.connectToBluetoothDevice(event.device);

    emit(state.copyWith(
        stateStatus: ReadersConnectBluetoothPairedStatus.connectToDeviceStatusUpdate,
        selectedBluetoothDevice: deviceConnectBluetoothResponse,
      ),
    );
  }
}