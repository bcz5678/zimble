part of 'readers_current_bloc.dart';

abstract class ReadersCurrentEvent extends Equatable{
  const ReadersCurrentEvent();

  @override
  List<Object> get props => [];
}

class ReadersCurrentlyAttachedChanged extends ReadersCurrentEvent{
  const ReadersCurrentlyAttachedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}