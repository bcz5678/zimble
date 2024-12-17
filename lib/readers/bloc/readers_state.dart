part of 'readers_bloc.dart';

enum ReadersStatus {
  initial,
  currentlyConnectedReaderUpdated,
}

class ReadersState extends Equatable {
  const ReadersState({
    this.stateStatus,
    this.currentlyConnectedReaders,
  });

  const ReadersState.initial()
      : this(
    stateStatus: ReadersStatus.initial,
  );

final ReadersStatus? stateStatus;
final List<Reader>? currentlyConnectedReaders;

  @override
  List<Object?> get props => [
    stateStatus,
    currentlyConnectedReaders,
  ];

  ReadersState copyWith({
    ReadersStatus? stateStatus,
    List<Reader>? currentlyConnectedReaders,
  }) {
    return ReadersState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyConnectedReaders: currentlyConnectedReaders ?? this.currentlyConnectedReaders,
    );
  }
}
