part of 'error_bloc.dart';

enum ErrorStatus {
  initial,
  errorUpdated,
}

class ErrorState extends Equatable {
  const ErrorState({
    required this.status,
    this.error,
  });

  final ErrorStatus status;
  final Error? error;

  const ErrorState.initial()
      : this(
    status: ErrorStatus.initial,
  );

  @override
  List<Object?> get props => [error];

  ErrorState copyWith({
    ErrorStatus? status,
    Error? error,
  }) =>
      ErrorState(
        status: status ?? this.status,
        error: error ?? this.error,
      );
}