import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_network_event.dart';
part 'readers_network_state.dart';

class ReadersNetworkBloc extends Bloc<ReadersNetworkEvent, ReadersNetworkState> {
  ReadersNetworkBloc({
    required ReaderRepository readerRepository,
  }) : _readerRepository = readerRepository,
    super(ReadersNetworkState.initial()) {
    _networkReadersSubscription = _readerRepository.networkReadersList.listen(_networkReadersListChanged);
  }

  final ReaderRepository _readerRepository;

  late StreamSubscription<List<Reader>> _networkReadersSubscription;

  void _networkReadersListChanged(List<Reader> readers) {
  // [DEBUG TEST]
  if (kDebugMode) {
    print("readers_main_bloc -> _networkReadersListChanged - adding - ${readers}");
  }
    add(ReadersNetworkChanged(readers));
  }

  @override
  Future<void> close() async {
    _networkReadersSubscription.cancel();
    super.close();
  }

}
