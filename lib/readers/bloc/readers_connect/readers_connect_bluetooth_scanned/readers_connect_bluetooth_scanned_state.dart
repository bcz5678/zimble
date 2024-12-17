part of 'readers_connect_bluetooth_scanned_bloc.dart';

enum ReadersConnectBluetoothScannedStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersConnectBluetoothScannedState {
  const ReadersConnectBluetoothScannedState({
    required this.stateStatus,
    this.bluetoothScannedReaders,
  });

  const ReadersConnectBluetoothScannedState.initial()
  : this(
    stateStatus: ReadersConnectBluetoothScannedStatus.initial
  );

  final ReadersConnectBluetoothScannedStatus? stateStatus;
  final List<Reader>? bluetoothScannedReaders;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothScannedReaders,
  ];

  ReadersConnectBluetoothScannedState copyWith({
    ReadersConnectBluetoothScannedStatus? stateStatus,
    List<Reader>? bluetoothScannedReaders,
  }) {
    return ReadersConnectBluetoothScannedState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothScannedReaders: bluetoothScannedReaders ?? this.bluetoothScannedReaders,
    );
  }

}
