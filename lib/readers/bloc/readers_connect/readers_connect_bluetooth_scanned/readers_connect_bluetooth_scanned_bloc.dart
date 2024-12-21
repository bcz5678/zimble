import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_connect_bluetooth_scanned_event.dart';
part 'readers_connect_bluetooth_scanned_state.dart';

class ReadersConnectBluetoothScannedBloc extends Bloc<ReadersConnectBluetoothScannedEvent, ReadersConnectBluetoothScannedState> {
  ReadersConnectBluetoothScannedBloc({
    required ReaderRepository readerRepository,
  }) : _readerRepository = readerRepository,
        super(ReadersConnectBluetoothScannedState.initial()) {

    ///Add changes to bt scanned readers to the
    ///Readers_connect_bluetooth_scanned_event handlers
    _bluetoothScannedReadersSubscription =
        _readerRepository.bluetoothScannedReadersList
            .handleError(onError)
            .listen((readers) => add(ReadersConnectBluetoothScannedChanged(readers)));
  }

  /// Initialize readerRepository and _bluetoothScannedReadersSubscription
  /// to handle changes to the bluetooth list
  final ReaderRepository _readerRepository;
  late StreamSubscription<List<Reader>> _bluetoothScannedReadersSubscription;


  @override
  Future<void> close() async {
    _bluetoothScannedReadersSubscription.cancel();
    super.close();
  }
}
