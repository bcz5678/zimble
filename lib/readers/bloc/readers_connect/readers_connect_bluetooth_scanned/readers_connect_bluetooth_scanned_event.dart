part of 'readers_connect_bluetooth_scanned_bloc.dart';

abstract class ReadersConnectBluetoothScannedEvent extends Equatable{
  const ReadersConnectBluetoothScannedEvent();

  @override
  List<Object> get props => [];
}

class StartScanningBluetoothDevices extends ReadersConnectBluetoothScannedEvent{
  const StartScanningBluetoothDevices();
}

class StopScanningBluetoothDevices extends ReadersConnectBluetoothScannedEvent{
  const StopScanningBluetoothDevices();
}


class ReadersConnectBluetoothScannedConnect extends ReadersConnectBluetoothScannedEvent{
  const ReadersConnectBluetoothScannedConnect(this.device);

  final List<BluetoothDevice> device;

  @override
  List<Object> get props => [device];
}

class ReadersConnectBluetoothScannedDisConnect extends ReadersConnectBluetoothScannedEvent{
  const ReadersConnectBluetoothScannedDisConnect(this.device);

  final List<BluetoothDevice> device;

  @override
  List<Object> get props => [device];
}
