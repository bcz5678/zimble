import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';

part 'readers_current_event.dart';
part 'readers_current_state.dart';

class ReadersCurrentBloc extends Bloc<ReadersCurrentEvent, ReadersCurrentState> {
  ReadersCurrentBloc() :
        super(ReadersCurrentState.initial()) {
    on<StartSensorStream> (onStartSensorStream);
    on<StopSensorStream> (onStopSensorStream);
  }


  void onStartSensorStream(
      StartSensorStream event,
      Emitter<ReadersCurrentState> emit,
      ) async {


  }

  void onStopSensorStream(
      StopSensorStream event,
      Emitter<ReadersCurrentState> emit,
      ) async {


  }


  @override
  Future<void> close() async {
    super.close();
  }

}
