part of 'readers_bloc.dart';

abstract class ReadersEvent extends Equatable{
  const ReadersEvent();

  @override
  List<Object> get props => [];
}


class ReadersCurrentlyConnectedChanged extends ReadersEvent{
  const ReadersCurrentlyConnectedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}