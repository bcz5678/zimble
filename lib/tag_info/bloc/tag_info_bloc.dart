import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tag_info_event.dart';
part 'tag_info_state.dart';

class TagInfoBloc extends Bloc<TagInfoEvent, TagInfoState> {
  TagInfoBloc() : super(TagInfoInitial()) {
    on<TagInfoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
