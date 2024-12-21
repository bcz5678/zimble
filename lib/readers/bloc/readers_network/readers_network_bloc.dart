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

    ///Add changes to networked readers to the Readers_network_event handlers
    _networkReadersSubscription = _readerRepository.networkReadersList
        .handleError(onError)
        .listen((readers) => add(ReadersNetworkChanged(readers)));
  }

  /// Initialize readerRepository and _networksSubscription to handle changes
  /// to the networkReaders list
  final ReaderRepository _readerRepository;
  late StreamSubscription<List<Reader>> _networkReadersSubscription;


  @override
  Future<void> close() async {
    _networkReadersSubscription.cancel();
    super.close();
  }

}
