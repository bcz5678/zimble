part of 'readers_attached_bloc.dart';

enum ReadersAttachedStatus {
  initial,
  loading,
  done,
  error,
  currentlyAttachedReadersListUpdated,
}

class ReadersAttachedState {
  ReadersAttachedState({
    required this.stateStatus,
    this.currentlyAttachedReadersList,
  });

  ReadersAttachedState.initial()
      : this(
    stateStatus: ReadersAttachedStatus.initial,
  );

  final ReadersAttachedStatus? stateStatus;
  late List<Reader>? currentlyAttachedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    currentlyAttachedReadersList,
  ];

  ReadersAttachedState copyWith({
    ReadersAttachedStatus? stateStatus,
    List<Reader>? currentlyAttachedReadersList,
  }) {
    return ReadersAttachedState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyAttachedReadersList: currentlyAttachedReadersList ?? this.currentlyAttachedReadersList,
    );
  }

}