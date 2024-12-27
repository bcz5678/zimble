part of 'readers_current_bloc.dart';

enum ReadersCurrentStatus {
  initial,
  loading,
  done,
  error,
  sensorStreamStarted,
  sensorStreamStopped,
}

class ReadersCurrentState {
  ReadersCurrentState({
    required this.stateStatus,
    this.currentlyAttachedReaders,
    this.sensorValues,
  });

  ReadersCurrentState.initial()
      : this(
    stateStatus: ReadersCurrentStatus.initial,
  );

  final ReadersCurrentStatus? stateStatus;
  late List<Reader>? currentlyAttachedReaders;
  late List<List<String>>? sensorValues;


  @override
  List<Object?> get props =>
      [
        stateStatus,
        currentlyAttachedReaders,
        sensorValues,
      ];

  ReadersCurrentState copyWith({
    ReadersCurrentStatus? stateStatus,
    List<Reader>? currentlyAttachedReaders,
    List<List<String>>? sensorValues,
  }) {
    return ReadersCurrentState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyAttachedReaders: currentlyAttachedReaders ?? this.currentlyAttachedReaders,
      sensorValues: sensorValues ?? this.sensorValues,
    );
  }


}
