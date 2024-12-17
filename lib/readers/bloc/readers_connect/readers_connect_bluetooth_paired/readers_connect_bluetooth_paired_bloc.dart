import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_connect_bluetooth_paired_event.dart';
part 'readers_connect_bluetooth_paired_state.dart';

class ReadersConnectBluetoothPairedBloc extends Bloc<ReadersConnectBluetoothPairedEvent, ReadersConnectBluetoothPairedState> {
  ReadersConnectBluetoothPairedBloc({
    required ReaderRepository readerRepository,
  })
      : _readerRepository = readerRepository,
        super(ReadersConnectBluetoothPairedState.initial()) {
    _bluetoothPairedReadersSubscription =
        _readerRepository.bluetoothPairedReadersList.listen(
            _bluetoothPairedReadersListChanged);
  }

  final ReaderRepository _readerRepository;
  late StreamSubscription<List<Reader>> _bluetoothPairedReadersSubscription;

  void _bluetoothPairedReadersListChanged(List<Reader> readers) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print(
          "readers_connect_paired_bloc -> _bluetoothPairedReadersListChanged - adding - ${readers}");
    }
    add(ReadersConnectBluetoothPairedChanged(readers));
  }

  @override
  Future<void> close() async {
    _bluetoothPairedReadersSubscription.cancel();
  }
}