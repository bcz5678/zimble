import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart' show AccelerationData, SensorData;
import 'package:reader_repository/reader_repository.dart';

part 'readers_current_event.dart';
part 'readers_current_state.dart';

class ReadersCurrentBloc extends Bloc<ReadersCurrentEvent, ReadersCurrentState> {
  ReadersCurrentBloc({
    required ReaderRepository readerRepository,
  }) : _readerRepository = readerRepository,
        super(ReadersCurrentState.initial()) {
    on<StartSensorStream> (onStartSensorStream);
    on<StopSensorStream> (onStopSensorStream);
  }

  final ReaderRepository _readerRepository;

  void onStartSensorStream(
      StartSensorStream event,
      Emitter<ReadersCurrentState> emit,
      ) async {

    final startSensorStreamResult = await _readerRepository.startSensorStreams().toString();

    await emit.forEach(
      _readerRepository.sensorDataStreamAll,
      onData: (SensorData  sensorStreamData) {
        try {

          return state.copyWith(
            stateStatus: ReadersCurrentStatus.done,
            sensorValues: sensorStreamData,
          );
        } catch (error, stackTrace){
          return state.copyWith(
            stateStatus: ReadersCurrentStatus.error,
          );
        }
      },
    );
    transformer: restartable();
  }

  void onStopSensorStream(
      StopSensorStream event,
      Emitter<ReadersCurrentState> emit,
      ) async {

    final stopSensorStreamResult = await _readerRepository.stopSensorStreams().toString();

    if (kDebugMode) {
      print('readers_current_bloc -> onStopSensorstream -> stopSensorStreamResult - ${stopSensorStreamResult}');
    }

    emit(state.copyWith(
      stateStatus: ReadersCurrentStatus.done,
      //[TODO] add sensorValues in after conversion
      // sensorValues: TBD,
    ),
    );

  }


  @override
  Future<void> close() async {
    super.close();
  }

}
