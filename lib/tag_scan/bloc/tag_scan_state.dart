part of 'tag_scan_bloc.dart';

enum TagScanStatus {
  initial,
  done,
  loading,
  scanStartInProgress,
  scanStopInProgress,
  scanStarted,
  scanUpdated,
  scanStopped,
}

class TagScanState extends Equatable{
  TagScanState({
    this.stateStatus,
    this.currentlyUpdatedTagList,
  });

  TagScanState.initial()
      : this (
    stateStatus: TagScanStatus.initial,
  );

  final TagScanStatus? stateStatus;
  final List<TagData>? currentlyUpdatedTagList;

  @override
  List<Object?> get props => [
    stateStatus,
    currentlyUpdatedTagList
  ];

  TagScanState copyWith({
    TagScanStatus? stateStatus,
    List<TagData>? currentlyUpdatedTagList,
  }) {
    return TagScanState(
      stateStatus: stateStatus ?? this.stateStatus,
      currentlyUpdatedTagList: currentlyUpdatedTagList ?? this.currentlyUpdatedTagList,
    );
  }

}


