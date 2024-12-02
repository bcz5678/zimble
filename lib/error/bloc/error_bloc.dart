import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

part 'error_event.dart';
part 'error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc(
      GoException? error,
      ) : super(const ErrorState.initial()) {
    on<RouteError>(_onRouteError);
  }

  void _onRouteError(
    RouteError event,
    Emitter<ErrorState> emit,
  ){
    emit(
      state.copyWith(
        error: event.error,
        status: ErrorStatus.errorUpdated,
      ),
    );
  }
}