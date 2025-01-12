part of 'readers_bloc.dart';

abstract class ReadersEvent extends Equatable{
  const ReadersEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentlyConnectedReadersList extends ReadersEvent {
  const GetCurrentlyConnectedReadersList();
}

class CurrentlyConnectedReadersListChanged extends ReadersEvent {
  const CurrentlyConnectedReadersListChanged(this.currentlyConnectedReadersList);

  final List<Reader> currentlyConnectedReadersList;

  @override
  List<Object> get props => [currentlyConnectedReadersList];
}
