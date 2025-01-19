part of 'readers_sensors_bloc.dart';

enum ReadersSensorsStatus {
  initial,
  loading,
  done,
  error,
  sensorStreamStarted,
  sensorStreamStopped,
}

class ReadersSensorsState extends Equatable {
  ReadersSensorsState({
    required this.stateStatus,
    this.currentlyAttachedReaders,
    this.sensorValues,
  });

  ReadersSensorsState.initial()
      : this(
    stateStatus: ReadersSensorsStatus.initial,
  );

  final ReadersSensorsStatus? stateStatus;
  late List<Reader>? currentlyAttachedReaders;
  late SensorData? sensorValues;


  @override
  List<Object?> get props =>
      [
        stateStatus,
        currentlyAttachedReaders,
        sensorValues,
      ];

  ReadersSensorsState copyWith({
    ReadersSensorsStatus? stateStatus,
    List<Reader>? currentlyAttachedReaders,
    SensorData? sensorValues,
  }) {
    return ReadersSensorsState (
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyAttachedReaders: currentlyAttachedReaders ?? this.currentlyAttachedReaders,
      sensorValues: sensorValues ?? this.sensorValues,
    );
  }
}
