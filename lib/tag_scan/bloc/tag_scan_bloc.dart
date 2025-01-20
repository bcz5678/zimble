import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tag_scan_event.dart';
part 'tag_scan_state.dart';

class TagScanBloc extends Bloc<TagScanEvent, TagScanState> {
  TagScanBloc() : super(TagScanInitial()) {
    on<TagScanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
