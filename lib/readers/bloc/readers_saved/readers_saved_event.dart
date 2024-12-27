part of 'readers_saved_bloc.dart';

abstract class ReadersSavedEvent  extends Equatable{
  const ReadersSavedEvent();

  @override
  List<Object> get props => [];
}

class ReadersSavedChanged extends ReadersSavedEvent{
  const ReadersSavedChanged(this.devices);

  final List<GenericDevice> devices;

  @override
  List<Object> get props => [devices];
}
