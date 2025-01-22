part of 'readers_bloc.dart';

enum ReadersStatus {
  initial,
  done,
  currentlyAttachedReaderUpdated,
}

class ReadersState extends Equatable {
  ReadersState({
    this.stateStatus,
    this.currentlyAttachedReadersList,
  });

  ReadersState.initial()
      : this(
    stateStatus: ReadersStatus.initial,
  );

final ReadersStatus? stateStatus;
final List<Reader>? currentlyAttachedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    currentlyAttachedReadersList,
  ];

  ReadersState copyWith({
    ReadersStatus? stateStatus,
    List<Reader>? currentlyAttachedReadersList,
  }) {
    return ReadersState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyAttachedReadersList: currentlyAttachedReadersList ?? this.currentlyAttachedReadersList,
    );
  }
}
