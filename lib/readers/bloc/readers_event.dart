part of 'readers_bloc.dart';

abstract class ReadersEvent extends Equatable{
  const ReadersEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentlyAttachedReadersList extends ReadersEvent {
  const GetCurrentlyAttachedReadersList();
}

class currentlyAttachedReadersListChanged extends ReadersEvent {
  const currentlyAttachedReadersListChanged(this.currentlyAttachedReadersList);

  final List<Reader> currentlyAttachedReadersList;

  @override
  List<Object> get props => [currentlyAttachedReadersList];
}
