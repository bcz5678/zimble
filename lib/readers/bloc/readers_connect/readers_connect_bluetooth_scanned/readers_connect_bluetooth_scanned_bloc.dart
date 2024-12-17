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
    _bluetoothScannedReadersSubscription =
        _readerRepository.bluetoothScannedReadersList.listen(
            _bluetoothScannedReadersListChanged);
  }

  final ReaderRepository _readerRepository;
  late StreamSubscription<List<Reader>> _bluetoothScannedReadersSubscription;

  void _bluetoothScannedReadersListChanged(List<Reader> readers) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print("readers_main_bloc -> _bluetoothScannedReadersListChanged - adding - ${readers}");
    }
    add(ReadersConnectBluetoothScannedChanged(readers));
  }

  @override
  Future<void> close() async {
    _bluetoothScannedReadersSubscription.cancel();
    super.close();
  }
}
