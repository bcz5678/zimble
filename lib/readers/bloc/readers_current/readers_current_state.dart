part of 'readers_current_bloc.dart';

enum ReadersCurrentStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersCurrentState {
  ReadersCurrentState({
    required this.stateStatus,
    this.currentlyAttachedReaders,
  });

  ReadersCurrentState.initial()
      : this(
    stateStatus: ReadersCurrentStatus.initial,
  );

  final ReadersCurrentStatus? stateStatus;
  late List<Reader>? currentlyAttachedReaders;


  @override
  List<Object?> get props =>
      [
        stateStatus,
        currentlyAttachedReaders,
      ];

  ReadersCurrentState copyWith({
    ReadersCurrentStatus? stateStatus,
    List<Reader>? currentlyAttachedReaders,
  }) {
    return ReadersCurrentState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyAttachedReaders: currentlyAttachedReaders ?? this.currentlyAttachedReaders,
    );
  }
}
