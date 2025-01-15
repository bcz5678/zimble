part of 'readers_connect_bloc.dart';

enum ReadersConnectStatus {
  mainInitial,
  pairedInitial,
  pairedLoading,
  pairedDone,
  pairedError,
  pairedBluetoothDevicesUpdated,
  scannedInitial,
  scannedLoading,
  scannedDone,
  scannedError,
  scannedBluetoothDevicesUpdated,
  connectToDeviceStatusInProgress,
  connectToDeviceStatusUpdate,
}

class ReadersConnectState {
  const ReadersConnectState({
    required this.stateStatus,
    this.bluetoothPairedDevicesList,
    this.bluetoothScannedDevicesList,
    this.selectedBluetoothDevice,
    this.currentlyConnectedReadersList,
  });

  const ReadersConnectState.initial()
      : this(
    stateStatus: ReadersConnectStatus.mainInitial,
  );

  final ReadersConnectStatus? stateStatus;
  final List<BluetoothDevice>? bluetoothPairedDevicesList;

  final List<BluetoothDevice>? bluetoothScannedDevicesList;
  final BluetoothDevice? selectedBluetoothDevice;
  final List<Reader>? currentlyConnectedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothPairedDevicesList,
    bluetoothScannedDevicesList,
    selectedBluetoothDevice,
    currentlyConnectedReadersList,
  ];

  ReadersConnectState copyWith({
    ReadersConnectStatus? stateStatus,
    List<BluetoothDevice>? bluetoothPairedDevicesList,
    List<BluetoothDevice>? bluetoothScannedDevicesList,
    BluetoothDevice? selectedBluetoothDevice,
    List<Reader>? currentlyConnectedReadersList,
  }) {
    return ReadersConnectState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothPairedDevicesList: bluetoothPairedDevicesList ?? this.bluetoothPairedDevicesList,
      bluetoothScannedDevicesList: bluetoothScannedDevicesList ?? this.bluetoothScannedDevicesList,
      selectedBluetoothDevice: selectedBluetoothDevice ?? this.selectedBluetoothDevice,
      currentlyConnectedReadersList: currentlyConnectedReadersList ?? this.currentlyConnectedReadersList,
    );
  }
}
