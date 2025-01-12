part of 'readers_connect_bluetooth_paired_bloc.dart';

enum ReadersConnectBluetoothPairedStatus {
  initial,
  loading,
  done,
  error,
  connectToDeviceStatusLoading,
  connectToDeviceStatusUpdate,
}

class ReadersConnectBluetoothPairedState {
  const ReadersConnectBluetoothPairedState({
    required this.stateStatus,
    this.bluetoothPairedDevicesList,
    this.selectedBluetoothDevice,
    this.currentlyConnectedReadersList,
  });

  const ReadersConnectBluetoothPairedState.initial()
      : this(
    stateStatus: ReadersConnectBluetoothPairedStatus.initial,
  );

  final ReadersConnectBluetoothPairedStatus? stateStatus;
  final List<BluetoothDevice>? bluetoothPairedDevicesList;
  final BluetoothDevice? selectedBluetoothDevice;
  final List<Reader>? currentlyConnectedReadersList;

  @override
  List<Object?> get props => [
    stateStatus,
    bluetoothPairedDevicesList,
    selectedBluetoothDevice,
    currentlyConnectedReadersList,
  ];

  ReadersConnectBluetoothPairedState copyWith({
    ReadersConnectBluetoothPairedStatus? stateStatus,
    List<BluetoothDevice>? bluetoothPairedDevicesList,
    BluetoothDevice? selectedBluetoothDevice,
    List<Reader>? currentlyConnectedReadersList,
  }) {
    return ReadersConnectBluetoothPairedState (
      stateStatus: stateStatus ?? this.stateStatus,
      bluetoothPairedDevicesList: bluetoothPairedDevicesList ?? this.bluetoothPairedDevicesList,
      selectedBluetoothDevice: selectedBluetoothDevice ?? this.selectedBluetoothDevice,
      currentlyConnectedReadersList: currentlyConnectedReadersList ?? this.currentlyConnectedReadersList,
    );
  }
}
