import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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

        //Clear the prior version of the tag scan list
        state.currentScanTagDataList?.clear();

        if(kDebugMode) {
          print('tag_scan_bloc -> onTagScanStart -> ${state.currentScanTagDataList}');
        }

        final tagScanStartResponse = await _readerRepository.startTagScanStream();

       await emit.forEach(
          _readerRepository.tagDataScanStream,
          onData: (TagScanData tagScanDataItem) {

            _processNewTagScanData(tagScanDataItem);

            if(kDebugMode) {
              print('tag_scan_bloc -> onTagScanStart -> ${state.currentScanTagDataList!.reversed.toList()}');
            }
            try{
              return state.copyWith(
                stateStatus: TagScanStatus.scanUpdated,
                currentScanTagDataList: state.currentScanTagDataList!.reversed.toList(),
              );
            } catch (error, stackTrace) {
              return state.copyWith(
                stateStatus: TagScanStatus.error,
              );
            }
          },
        );
        transformer: restartable();
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

  void _processNewTagScanData(TagScanData tagScanDataItem) {
    //local copy of current list for performance
    var _currentTagScanDataList = state.currentScanTagDataList;

    //Checks if _currentTagScanDataList has entries
    if(_currentTagScanDataList != null && _currentTagScanDataList.isNotEmpty) {
      if(kDebugMode) {
        print('tag_scan_bloc -> _processNewTagScanData -> pre -> ${_currentTagScanDataList}');
      }

      //CHeck if EPC is already in the list
      var firstTagEpcIndex = _currentTagScanDataList.indexWhere((item) => item["epc"] == tagScanDataItem.epc);

      if(firstTagEpcIndex != -1) {

        //EPC already in teh list, increment numberTimesSeen for this iteration and the current rssi
        _currentTagScanDataList[firstTagEpcIndex]["numberTimesSeen"]++;
        _currentTagScanDataList[firstTagEpcIndex]["tagScanData"] = tagScanDataItem;

        //push the updated local copy of the list to state.currentScanTagDataList
        state.currentScanTagDataList = _currentTagScanDataList;
      } else {

        //List is not empty but this is the first instnace of this EPC
        // - >  create entry in state.currentScanTagDataList?
        state.currentScanTagDataList?.add({"epc": tagScanDataItem.epc, "numberTimesSeen" : 1, "tagScanData": tagScanDataItem});
      }
    } else {

      //No Entries, so adds first to the state.currentScanTagDataList
      if(kDebugMode) {
        print('tag_scan_bloc -> _processNewTagScanData -> emptyToStart -> ${state.currentScanTagDataList}');
      }
      state.currentScanTagDataList?.add({"epc": tagScanDataItem.epc, "numberTimesSeen" : 1, "tagScanData": tagScanDataItem});
      if(kDebugMode) {
        print('tag_scan_bloc -> _processNewTagData -> post -> ${state.currentScanTagDataList}');
      }
    }
  }
}

