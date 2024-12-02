part of 'error_bloc.dart';

abstract class ErrorEvent extends Equatable {
  const ErrorEvent();
}

class RouteError extends ErrorEvent {
  const RouteError(this.error);

  final Error error;

  @override
  List<Object> get props => [error];
}