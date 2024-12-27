import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_saved_event.dart';
part 'readers_saved_state.dart';

class ReadersSavedBloc extends Bloc<ReadersSavedEvent, ReadersSavedState> {
  ReadersSavedBloc({
    required ReaderRepository readerRepository,
  })
      : _readerRepository = readerRepository,
        super(ReadersSavedState.initial()) {

    _savedDevicesSubscription =
        _readerRepository.savedDevicesList
            .handleError(onError)
            .listen((devices) => add(ReadersSavedChanged(devices)));
  }


  final ReaderRepository _readerRepository;
  late StreamSubscription<List<GenericDevice>> _savedDevicesSubscription;

  @override
  Future<void> close() async {
    _savedDevicesSubscription.cancel();
    super.close();
  }
}
