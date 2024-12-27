part of 'readers_connect_bluetooth_paired_bloc.dart';

abstract class ReadersConnectBluetoothPairedEvent extends Equatable{
  const ReadersConnectBluetoothPairedEvent();

  @override
  List<Object> get props => [];
}

class ReadersConnectBluetoothPairedChanged extends ReadersConnectBluetoothPairedEvent{
  const ReadersConnectBluetoothPairedChanged(this.devices);

  final List<BluetoothDevice> devices;

  @override
  List<Object> get props => [devices];
}

//Previously Paired SubTab
class GetPairedBluetoothDevices extends ReadersConnectBluetoothPairedEvent {
  const GetPairedBluetoothDevices();
}

class GetCurrentReader extends ReadersConnectBluetoothPairedEvent {
  const GetCurrentReader();
}

class CurrentlyConnectedReadersListChanged extends ReadersConnectBluetoothPairedEvent {
  const CurrentlyConnectedReadersListChanged(this.currentlyConnectedReadersList);

  final List<Reader> currentlyConnectedReadersList;

  @override
  List<Object> get props => [currentlyConnectedReadersList];
}


class ConnectToBluetoothDevice extends ReadersConnectBluetoothPairedEvent {
  const ConnectToBluetoothDevice(this.device);

  final BluetoothDevice device;

  @override
  List<Object> get props => [device];
}

class DisconnectFromBluetoothDevice extends ReadersConnectBluetoothPairedEvent {
  const DisconnectFromBluetoothDevice(this.device);

  final BluetoothDevice device;

  @override
  List<Object> get props => [device];
}