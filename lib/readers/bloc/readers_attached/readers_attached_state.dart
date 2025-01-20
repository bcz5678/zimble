part of 'readers_attached_bloc.dart';

enum ReadersAttachedStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersAttachedState {
  ReadersAttachedState({
    required this.stateStatus,
  });

  ReadersAttachedState.initial()
      : this(
    stateStatus: ReadersAttachedStatus.initial,
  );

  final ReadersAttachedStatus? stateStatus;

  @override
  List<Object?> get props => [
    stateStatus,
  ];

  ReadersAttachedState copyWith({
    ReadersAttachedStatus? stateStatus,
  }) {
    return ReadersAttachedState (
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }

}