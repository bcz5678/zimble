part of 'readers_connect_bluetooth_scanned_bloc.dart';

abstract class ReadersConnectBluetoothScannedEvent extends Equatable{
  const ReadersConnectBluetoothScannedEvent();

  @override
  List<Object> get props => [];
}

class ReadersConnectBluetoothScannedChanged extends ReadersConnectBluetoothScannedEvent{
  const ReadersConnectBluetoothScannedChanged(this.devices);

  final List<BluetoothDevice> devices;

  @override
  List<Object> get props => [devices];
}