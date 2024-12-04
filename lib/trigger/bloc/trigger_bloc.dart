import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'trigger_event.dart';
part 'trigger_state.dart';

class TriggerBloc extends Bloc<TriggerEvent, TriggerState> {
  TriggerBloc() : super(TriggerInitial()) {
    on<TriggerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
