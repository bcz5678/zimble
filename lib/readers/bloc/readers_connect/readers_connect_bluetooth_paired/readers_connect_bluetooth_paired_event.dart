part of 'readers_connect_bluetooth_paired_bloc.dart';

abstract class ReadersConnectBluetoothPairedEvent extends Equatable{
  const ReadersConnectBluetoothPairedEvent();

  @override
  List<Object> get props => [];
}

class ReadersConnectBluetoothPairedChanged extends ReadersConnectBluetoothPairedEvent{
  const ReadersConnectBluetoothPairedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}

//Previously Paired SubTab
class GetPairedBluetoothDevices extends ReadersConnectBluetoothPairedEvent {
  const GetPairedBluetoothDevices();
}

class GetCurrentReader extends ReadersConnectBluetoothPairedEvent {
  const GetCurrentReader();
}


class ConnectToBluetoothDevice extends ReadersConnectBluetoothPairedEvent {
  const ConnectToBluetoothDevice(this.reader);

  final Reader reader;

  @override
  List<Object> get props => [reader];
}

class DisconnectFromBluetoothDevice extends ReadersConnectBluetoothPairedEvent {
  const DisconnectFromBluetoothDevice(this.reader);

  final Reader reader;

  @override
  List<Object> get props => [reader];
}