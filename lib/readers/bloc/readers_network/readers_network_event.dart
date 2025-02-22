part of 'readers_network_bloc.dart';

abstract class ReadersNetworkEvent extends Equatable{
  const ReadersNetworkEvent();

  @override
  List<Object> get props => [];
}

class ReadersNetworkChanged extends ReadersNetworkEvent{
  const ReadersNetworkChanged(this.devices);

  final List<NetworkDevice> devices;

  @override
  List<Object> get props => [devices];
}
