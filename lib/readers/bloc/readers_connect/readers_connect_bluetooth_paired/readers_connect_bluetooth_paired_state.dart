part of 'readers_connect_bluetooth_paired_bloc.dart';

enum ReadersConnectBluetoothPairedStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersConnectBluetoothPairedState {
  const ReadersConnectBluetoothPairedState({
    required this.stateStatus,
    this.bluetoothPairedReaders,
  });

  const ReadersConnectBluetoothPairedState.initial()
      : this(
    stateStatus: ReadersConnectBluetoothPairedStatus.initial,
  );

  final ReadersConnectBluetoothPairedStatus? stateStatus;
  final List<Reader>? bluetoothPairedReaders;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothPairedReaders,
  ];

  ReadersConnectBluetoothPairedState copyWith({
    ReadersConnectBluetoothPairedStatus? stateStatus,
    List<Reader>? savedReaders,
  }) {
    return ReadersConnectBluetoothPairedState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothPairedReaders: savedReaders ?? this.bluetoothPairedReaders,
    );
  }

}
