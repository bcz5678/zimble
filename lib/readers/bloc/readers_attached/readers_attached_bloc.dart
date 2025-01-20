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
  }) : super (ReadersAttachedState.initial());

}
