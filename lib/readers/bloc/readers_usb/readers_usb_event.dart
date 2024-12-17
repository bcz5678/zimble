part of 'readers_usb_bloc.dart';

abstract class ReadersUsbEvent extends Equatable{
  const ReadersUsbEvent();

  @override
  List<Object> get props => [];
}

class ReadersUsbChanged extends ReadersUsbEvent{
  const ReadersUsbChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}