part of 'readers_connect_bluetooth_paired_bloc.dart';

enum ReadersConnectBluetoothPairedStatus {
  initial,
  loading,
  done,
  error,
  connectToDeviceStatusLoading,
  connectToDeviceStatusUpdate
}

class ReadersConnectBluetoothPairedState {
  const ReadersConnectBluetoothPairedState({
    required this.stateStatus,
    this.bluetoothPairedReaders,
    this.bluetoothDeviceToUpdate,
  });

  const ReadersConnectBluetoothPairedState.initial()
      : this(
    stateStatus: ReadersConnectBluetoothPairedStatus.initial,
  );

  final ReadersConnectBluetoothPairedStatus? stateStatus;
  final List<Reader>? bluetoothPairedReaders;
  final Reader? bluetoothDeviceToUpdate;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothPairedReaders,
    bluetoothDeviceToUpdate,
  ];

  ReadersConnectBluetoothPairedState copyWith({
    ReadersConnectBluetoothPairedStatus? stateStatus,
    List<Reader>? bluetoothPairedReaders,
    Reader? bluetoothDeviceToUpdate,
  }) {
    return ReadersConnectBluetoothPairedState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothPairedReaders: bluetoothPairedReaders ?? this.bluetoothPairedReaders,
    );
  }

}
