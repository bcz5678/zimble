import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tag_finder_event.dart';
part 'tag_finder_state.dart';

class TagFinderBloc extends Bloc<TagFinderEvent, TagFinderState> {
  TagFinderBloc() : super(TagFinderInitial()) {
    on<TagFinderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
