import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'readers_event.dart';
part 'readers_state.dart';

class ReadersBloc extends Bloc<ReadersEvent, ReadersState> {
  ReadersBloc() : super(ReadersInitial()) {
    on<ReadersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
