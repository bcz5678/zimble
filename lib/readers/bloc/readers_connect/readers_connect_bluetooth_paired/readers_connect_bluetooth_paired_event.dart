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
