import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_usb_event.dart';
part 'readers_usb_state.dart';

class ReadersUsbBloc extends Bloc<ReadersUsbEvent, ReadersUsbState> {
  ReadersUsbBloc({
    required ReaderRepository readerRepository,
  }) : _readerRepository = readerRepository,
    super(ReadersUsbState.initial()) {
    _usbReadersSubscription = _readerRepository.usbReadersList.listen(_usbReadersListChanged);
  }

  final ReaderRepository _readerRepository;

  late StreamSubscription<List<Reader>> _usbReadersSubscription;

  void _usbReadersListChanged(List<Reader> readers) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print("readers_main_bloc -> _usbReadersListChanged - adding - ${readers}");
    }
    add(ReadersUsbChanged(readers));
  }

  @override
  Future<void> close() async {
    _usbReadersSubscription.cancel();
    super.close();
  }

}
