part of 'readers_saved_bloc.dart';

abstract class ReadersSavedEvent  extends Equatable{
  const ReadersSavedEvent();

  @override
  List<Object> get props => [];
}

class ReadersSavedChanged extends ReadersSavedEvent{
  const ReadersSavedChanged(this.readers);

  final List<Reader> readers;

  @override
  List<Object> get props => [readers];
}
