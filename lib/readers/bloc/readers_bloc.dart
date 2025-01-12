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
})
  : _readerRepository = readerRepository,
    super(ReadersState.initial()) {
      on<GetCurrentlyConnectedReadersList> (onGetCurrentlyConnectedReadersList);
      on<CurrentlyConnectedReadersListChanged> (onCurrentlyConnectedReadersListChanged);

      _currentlyConnectedReadersSubscription =
          _readerRepository.currentlyConnectedReadersList
            .handleError(onError)
            .listen((readers) => add(CurrentlyConnectedReadersListChanged(readers)));
   }

  final ReaderRepository _readerRepository;

  late StreamSubscription<List<Reader>> _currentlyConnectedReadersSubscription;

  Future<void> onGetCurrentlyConnectedReadersList(
    GetCurrentlyConnectedReadersList event,
    Emitter<ReadersState> emit,
    ) async {

    final currentlyConnectedReadersListResponse =
      await _readerRepository.currentlyConnectedReadersList.last;

    emit(state.copyWith(
      stateStatus: ReadersStatus.done,
      currentlyConnectedReadersList: currentlyConnectedReadersListResponse,
      ),
    );
  }


  void onCurrentlyConnectedReadersListChanged (
        CurrentlyConnectedReadersListChanged event,
        Emitter<ReadersState> emit,
      ){

      emit(state.copyWith(
        stateStatus: ReadersStatus.done,
        currentlyConnectedReadersList: event.currentlyConnectedReadersList,
        ),
     );
  }

  @override
  Future<void> close() async {
    _currentlyConnectedReadersSubscription.cancel();
    super.close();
  }
}