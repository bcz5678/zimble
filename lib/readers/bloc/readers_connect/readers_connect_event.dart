part of 'readers_connect_bloc.dart';

abstract class ReadersConnectEvent extends Equatable{
  const ReadersConnectEvent();

  @override
  List<Object> get props => [];
}


//Previously Paired SubTab
class GetPairedBluetoothDevices extends ReadersConnectEvent {
  const GetPairedBluetoothDevices();
}

class StartScanningBluetoothDevices extends ReadersConnectEvent {
  const StartScanningBluetoothDevices();
}

class StopScanningBluetoothDevices extends ReadersConnectEvent {
  const StopScanningBluetoothDevices();
}

class ConnectToBluetoothDevice extends ReadersConnectEvent {
  const ConnectToBluetoothDevice(this.device);

  final BluetoothDevice device;

  @override
  List<Object> get props => [device];
}

class DisconnectFromBluetoothDevice extends ReadersConnectEvent {
  const DisconnectFromBluetoothDevice(this.device);

  final BluetoothDevice device;

  @override
  List<Object> get props => [device];
}
