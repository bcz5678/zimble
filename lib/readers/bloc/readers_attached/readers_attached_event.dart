part of 'readers_attached_bloc.dart';

abstract class ReadersAttachedEvent extends Equatable{
  ReadersAttachedEvent();
}


class CurrentlyAttachedReadersListUpdated extends ReadersAttachedEvent {
  CurrentlyAttachedReadersListUpdated(this.readersList) : super();

  final List<Reader> readersList;

  @override
  List<Object> get props => [readersList];
}
