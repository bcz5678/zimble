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
  connectionStatusInProgress,
  connectionStatusSuccess,
  connectionStatusFailed,
}

class ReadersConnectState {
  const ReadersConnectState({
    required this.stateStatus,
    this.bluetoothPairedDevicesList,
    this.bluetoothScannedDevicesList,
    this.selectedBluetoothDevice,
    this.currentlyAttachedReadersList,
  });

  const ReadersConnectState.initial()
      : this(
    stateStatus: ReadersConnectStatus.mainInitial,
  );

  final ReadersConnectStatus? stateStatus;
  final List<BluetoothDevice>? bluetoothPairedDevicesList;

  final List<BluetoothDevice>? bluetoothScannedDevicesList;
  final BluetoothDevice? selectedBluetoothDevice;
  final List<Reader>? currentlyAttachedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothPairedDevicesList,
    bluetoothScannedDevicesList,
    selectedBluetoothDevice,
    currentlyAttachedReadersList,
  ];

  ReadersConnectState copyWith({
    ReadersConnectStatus? stateStatus,
    List<BluetoothDevice>? bluetoothPairedDevicesList,
    List<BluetoothDevice>? bluetoothScannedDevicesList,
    BluetoothDevice? selectedBluetoothDevice,
    List<Reader>? currentlyAttachedReadersList,
  }) {
    return ReadersConnectState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothPairedDevicesList: bluetoothPairedDevicesList ?? this.bluetoothPairedDevicesList,
      bluetoothScannedDevicesList: bluetoothScannedDevicesList ?? this.bluetoothScannedDevicesList,
      selectedBluetoothDevice: selectedBluetoothDevice ?? this.selectedBluetoothDevice,
      currentlyAttachedReadersList: currentlyAttachedReadersList ?? this.currentlyAttachedReadersList,
    );
  }
}
