part of 'tag_scan_bloc.dart';

abstract class TagScanEvent extends Equatable{
  const TagScanEvent();

  @override
  List<Object> get props => [];

}

class TagScanStart extends TagScanEvent {
  const TagScanStart();
}

class TagScanStop extends TagScanEvent {
  const TagScanStop();
}
