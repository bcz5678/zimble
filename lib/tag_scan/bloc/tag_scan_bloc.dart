import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';

part 'tag_scan_event.dart';
part 'tag_scan_state.dart';

class TagScanBloc extends Bloc<TagScanEvent, TagScanState> {
  TagScanBloc({
    required ReaderRepository readerRepository,
  })
      : _readerRepository = readerRepository,
        super(TagScanState.initial()) {
    on<TagScanStart>(onTagScanStart);
    on<TagScanStop>(onTagScanStop);
}
  final ReaderRepository _readerRepository;

  void onTagScanStart(
      TagScanStart event,
      Emitter<TagScanState> emit,
      ) async {
        emit(state.copyWith(
          stateStatus: TagScanStatus.scanStartInProgress
        ));

        final tagScanStartResponse = await _readerRepository.startTagScanStream();

        emit(state.copyWith(
          stateStatus: TagScanStatus.scanStarted,
        ));
    }

  void onTagScanStop(
      TagScanStop event,
      Emitter<TagScanState> emit,
      ) async {
    emit(state.copyWith(
        stateStatus: TagScanStatus.scanStopInProgress
    ));

    try {

      final tagScanStopResponse = await _readerRepository.stopTagScanStream();

      if(kDebugMode) {
        print('tag_Scan_bloc -> onTagScanStop -> tagScanStopResponse -> ${tagScanStopResponse}');
      }

      emit(state.copyWith(
        stateStatus: TagScanStatus.scanStopped,
      ));
    } catch (e) {
      if(kDebugMode) {
        print('tag_Scan_bloc -> onTagScanStop -> error ${e}');
      }
    }
  }

}

