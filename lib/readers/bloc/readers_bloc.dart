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
      on<GetCurrentlyAttachedReadersList> (onGetCurrentlyAttachedReadersList);
      on<currentlyAttachedReadersListChanged> (oncurrentlyAttachedReadersListChanged);

      _currentlyAttachedReadersSubscription =
          _readerRepository.currentlyAttachedReadersList
            .handleError(onError)
            .listen((newReadersList) {

              if(kDebugMode) {
                print('readers_bloc - inSubscription - ${newReadersList}');
              }

              add(currentlyAttachedReadersListChanged(newReadersList));
            });
   }

  final ReaderRepository _readerRepository;

  late StreamSubscription<List<Reader>> _currentlyAttachedReadersSubscription;

  Future<void> onGetCurrentlyAttachedReadersList(
    GetCurrentlyAttachedReadersList event,
    Emitter<ReadersState> emit,
    ) async {

    final currentlyAttachedReadersListResponse =
      await _readerRepository.currentlyAttachedReadersList.last;

    emit(state.copyWith(
      stateStatus: ReadersStatus.done,
      currentlyAttachedReadersList: currentlyAttachedReadersListResponse,
      ),
    );
  }

  void oncurrentlyAttachedReadersListChanged (
        currentlyAttachedReadersListChanged event,
        Emitter<ReadersState> emit,
      ){

      emit(state.copyWith(
        stateStatus: ReadersStatus.currentlyAttachedReaderUpdated,
        currentlyAttachedReadersList: event.currentlyAttachedReadersList,
        ),
     );
  }

  @override
  Future<void> close() async {
    super.close();
  }
}