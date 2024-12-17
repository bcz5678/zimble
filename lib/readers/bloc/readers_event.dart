part of 'readers_bloc.dart';

abstract class ReadersEvent extends Equatable{
  const ReadersEvent();

  @override
  List<Object> get props => [];
}

class ReadersBluetoothPairedChanged extends ReadersEvent{
  const ReadersBluetoothPairedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}

class ReadersBluetoothScannedChanged extends ReadersEvent{
  const ReadersBluetoothScannedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}

class ReadersUsbChanged extends ReadersEvent{
  const ReadersUsbChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}

class ReadersNetworkChanged extends ReadersEvent{
  const ReadersNetworkChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}


class ReadersCurrentlyAttachedChanged extends ReadersEvent{
  const ReadersCurrentlyAttachedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}