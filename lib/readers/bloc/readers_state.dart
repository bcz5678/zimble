part of 'readers_bloc.dart';

enum ReadersStatus {
  initial,
  done,
  currentlyConnectedReaderUpdated,
}

class ReadersState extends Equatable {
  ReadersState({
    this.stateStatus,
    this.currentlyConnectedReadersList,
  });

  ReadersState.initial()
      : this(
    stateStatus: ReadersStatus.initial,
  );

final ReadersStatus? stateStatus;
final List<Reader>? currentlyConnectedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    currentlyConnectedReadersList,
  ];

  ReadersState copyWith({
    ReadersStatus? stateStatus,
    List<Reader>? currentlyConnectedReadersList,
  }) {
    return ReadersState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyConnectedReadersList: currentlyConnectedReadersList,
    );
  }
}
