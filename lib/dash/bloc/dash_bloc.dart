import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dash_event.dart';
part 'dash_state.dart';

class DashBloc extends Bloc<DashEvent, DashState> {
  DashBloc() : super(DashInitial()) {
    on<DashEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
