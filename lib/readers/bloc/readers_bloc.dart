import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'readers_event.dart';
part 'readers_state.dart';


class ReadersBloc extends Bloc<ReadersEvent, ReadersState> {
  ReadersBloc({
    required ReaderRepository readerRepository,
}) : _readerRepository = readerRepository,
        super(const ReadersState()) {
    //on<GetCurrentReaderMain>(onGetCurrentReaderMain);
    //on<UpdateCurrentReaderMain>(onUpdateCurrentReaderMain);

    _currentlyAttachedReadersSubscription = _readerRepository.currentlyAttachedReadersList.listen(_currentlyAttachedReadersListChanged);

  }

  final ReaderRepository _readerRepository;
  late StreamSubscription<List<Reader>> _currentlyAttachedReadersSubscription;

  void _currentlyAttachedReadersListChanged(List<Reader> readers) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print("readers_main_bloc -> _networkReadersListChanged - adding - ${readers}");
    }
    add(ReadersCurrentlyAttachedChanged(readers));
  }


  @override
  Future<void> close() async {
    _currentlyAttachedReadersSubscription.cancel();
    super.close();
  }
}