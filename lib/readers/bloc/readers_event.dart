part of 'readers_bloc.dart';

abstract class ReadersEvent extends Equatable{
  const ReadersEvent();

  @override
  List<Object> get props => [];
}


class ReadersCurrentlyAttachedChanged extends ReadersEvent{
  const ReadersCurrentlyAttachedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}