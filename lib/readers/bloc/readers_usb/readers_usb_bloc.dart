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

    _usbReadersSubscription = _readerRepository.usbReadersList
        .handleError(onError)
        .listen((readers) => add(ReadersUsbChanged(readers)));
  }

  final ReaderRepository _readerRepository;
  late StreamSubscription<List<Reader>> _usbReadersSubscription;


  @override
  Future<void> close() async {
    _usbReadersSubscription.cancel();
    super.close();
  }

}
