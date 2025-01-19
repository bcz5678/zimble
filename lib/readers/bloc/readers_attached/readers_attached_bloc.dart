import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'readers_attached_event.dart';
part 'readers_attached_state.dart';

class ReadersAttachedBloc extends Bloc<ReadersAttachedEvent, ReadersAttachedState> {
  ReadersAttachedBloc({
    required ReaderRepository readerRepository
  }) : super (ReadersAttachedState.initial()) {

    on<CurrentlyAttachedReadersListUpdated> (onCurrentlyAttachedReadersListUpdated);

    _currentlyAttachedReadersListSubscription =
        readerRepository.currentlyAttachedReadersList
        .handleError(addError)
        .listen((readersList) {
          if(kDebugMode) {
            print('readers_attached_bloc - in subscription listen - readersList - ${readersList}');
          }
          add(CurrentlyAttachedReadersListUpdated(readersList));
        });
  }

  late StreamSubscription<List<Reader>> _currentlyAttachedReadersListSubscription;


  void onCurrentlyAttachedReadersListUpdated (
    CurrentlyAttachedReadersListUpdated event,
    Emitter<ReadersAttachedState> emit,
  ) async {
    try {
      if(kDebugMode) {
        print('readers_attached_bloc - onCurrentlyAttachedReadersListUpdated - readersList - ${event.readersList}');
      }

      emit(
        state.copyWith(
          stateStatus: ReadersAttachedStatus.currentlyAttachedReadersListUpdated,
          currentlyAttachedReadersList: event.readersList,
        ),
      );
    } catch (error, stackTrace) {
      print('oncurrentlyattachedreaderslist updated -error - ${error}');
    }
  }
}
