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
  error
}

class TagScanState extends Equatable{
  TagScanState({
    this.stateStatus,
    this.currentScanTagDataList,
  });

  TagScanState.initial()
      : this (
    stateStatus: TagScanStatus.initial,
    currentScanTagDataList: [],
  );

  final TagScanStatus? stateStatus;
  late List<Map<String, dynamic>>? currentScanTagDataList;

  @override
  List<Object?> get props => [
    stateStatus,
    currentScanTagDataList
  ];

  TagScanState copyWith({
    TagScanStatus? stateStatus,
    List<Map<String, dynamic>>? currentScanTagDataList,
  }) {
    return TagScanState(
      stateStatus: stateStatus ?? this.stateStatus,
      currentScanTagDataList: currentScanTagDataList ?? this.currentScanTagDataList,
    );
  }

}


