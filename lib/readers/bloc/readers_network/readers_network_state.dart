part of 'readers_network_bloc.dart';

enum ReadersNetworkStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersNetworkState {
  const ReadersNetworkState({
    required this.stateStatus,
    this.networkReaders,
  });

  const ReadersNetworkState.initial()
      : this(
    stateStatus: ReadersNetworkStatus.initial,
  );

  final ReadersNetworkStatus? stateStatus;
  final List<Reader>? networkReaders;

  @override
  List<Object?> get props => [
    stateStatus,
    networkReaders,
  ];

  ReadersNetworkState copyWith({
    ReadersNetworkStatus? stateStatus,
    List<Reader>? networkReaders,
  }) {
    return ReadersNetworkState (
      stateStatus: stateStatus ?? this.stateStatus,
      networkReaders: networkReaders ?? this.networkReaders,
    );
  }
}
