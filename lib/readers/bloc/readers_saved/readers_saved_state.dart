part of 'readers_saved_bloc.dart';

enum ReadersSavedStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersSavedState extends Equatable{
  const ReadersSavedState({
    required this.stateStatus,
    this.savedReaders,
    this.error,
  });


  const ReadersSavedState.initial()
  : this(
    stateStatus: ReadersSavedStatus.initial,
  );

  final ReadersSavedStatus? stateStatus;
  final List<Reader>? savedReaders;
  final DioException? error;

  @override
  List<Object?> get props => [
    stateStatus,
    savedReaders,
    error,
  ];

  ReadersSavedState copyWith({
    ReadersSavedStatus? stateStatus,
    List<Reader>? savedReaders,
    DioException? error,
  }) {
    return ReadersSavedState (
      stateStatus: stateStatus ?? this.stateStatus,
      savedReaders: savedReaders ?? this.savedReaders,
      error: error ?? this.error,
    );
  }
}
