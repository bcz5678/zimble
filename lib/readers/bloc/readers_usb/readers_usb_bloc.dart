import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_usb_event.dart';
part 'readers_usb_state.dart';

class ReadersUsbBloc extends Bloc<ReadersUsbEvent, ReadersUsbState> {
  ReadersUsbBloc({
    required ReaderRepository readerRepository,
  }) : _readerRepository = readerRepository,
    super(ReadersUsbState.initial()) {

    _usbDevicesSubscription = _readerRepository.usbDevicesList
        .handleError(onError)
        .listen((devices) => add(ReadersUsbChanged(devices)));
  }

  final ReaderRepository _readerRepository;
  late StreamSubscription<List<UsbDevice>> _usbDevicesSubscription;


  @override
  Future<void> close() async {
    _usbDevicesSubscription.cancel();
    super.close();
  }

}
