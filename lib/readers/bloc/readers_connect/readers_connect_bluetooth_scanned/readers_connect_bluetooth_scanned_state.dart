part of 'readers_connect_bluetooth_scanned_bloc.dart';

enum ReadersConnectBluetoothScannedStatus {
  initial,
  loading,
  done,
  error,
  scannedBluetoothDevicesUpdated,
  connectToDeviceStatusLoading,
  connectToDeviceStatusUpdate
}

class ReadersConnectBluetoothScannedState {
  const ReadersConnectBluetoothScannedState({
    required this.stateStatus,
    this.bluetoothScannedDevicesList,
    this.selectedBluetoothDevice,
  });

  const ReadersConnectBluetoothScannedState.initial()
  : this(
    stateStatus: ReadersConnectBluetoothScannedStatus.initial
  );

  final ReadersConnectBluetoothScannedStatus? stateStatus;
  final List<BluetoothDevice>? bluetoothScannedDevicesList;
  final BluetoothDevice? selectedBluetoothDevice;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothScannedDevicesList,
    selectedBluetoothDevice,
  ];

  ReadersConnectBluetoothScannedState copyWith({
    ReadersConnectBluetoothScannedStatus? stateStatus,
    List<BluetoothDevice>? bluetoothScannedDevicesList,
    BluetoothDevice? selectedBluetoothDevice,
    List<Reader>? currentlyConnectedReadersList,
  }) {
    return ReadersConnectBluetoothScannedState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothScannedDevicesList: bluetoothScannedDevicesList ?? this.bluetoothScannedDevicesList,
      selectedBluetoothDevice: selectedBluetoothDevice ?? this.selectedBluetoothDevice,
    );
  }

}
