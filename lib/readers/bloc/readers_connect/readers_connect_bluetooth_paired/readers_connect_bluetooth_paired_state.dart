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
    this.bluetoothPairedDevices,
    this.bluetoothDeviceToUpdate,
    this.currentlyConnectedReadersList,
  });

  const ReadersConnectBluetoothPairedState.initial()
      : this(
    stateStatus: ReadersConnectBluetoothPairedStatus.initial,
  );

  final ReadersConnectBluetoothPairedStatus? stateStatus;
  final List<BluetoothDevice>? bluetoothPairedDevices;
  final BluetoothDevice? bluetoothDeviceToUpdate;
  final List<Reader>? currentlyConnectedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothPairedDevices,
    bluetoothDeviceToUpdate,
    currentlyConnectedReadersList,
  ];

  ReadersConnectBluetoothPairedState copyWith({
    ReadersConnectBluetoothPairedStatus? stateStatus,
    List<BluetoothDevice>? bluetoothPairedDevices,
    BluetoothDevice? bluetoothDeviceToUpdate,
    List<Reader>? currentlyConnectedReadersList,
  }) {
    return ReadersConnectBluetoothPairedState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothPairedDevices: bluetoothPairedDevices ?? this.bluetoothPairedDevices,
      bluetoothDeviceToUpdate: bluetoothDeviceToUpdate ?? this.bluetoothDeviceToUpdate,
      currentlyConnectedReadersList: currentlyConnectedReadersList ?? this.currentlyConnectedReadersList,
    );
  }
}
