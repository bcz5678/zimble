part of 'readers_usb_bloc.dart';

enum ReadersUsbStatus {
  initial,
  loading,
  done,
  error,
}

class ReadersUsbState {
  const ReadersUsbState({
    required this.stateStatus,
    this.usbReaders,
});

  const ReadersUsbState.initial()
      : this(
    stateStatus: ReadersUsbStatus.initial,
  );

  final ReadersUsbStatus? stateStatus;
  final List<Reader>? usbReaders;

  List<Object?> get props => [
    stateStatus,
    usbReaders,
  ];

  ReadersUsbState copyWith({
    ReadersUsbStatus? stateStatus,
    List<Reader>? usbReaders,
  }) {
    return ReadersUsbState (
      stateStatus: stateStatus ?? this.stateStatus,
      usbReaders: usbReaders ?? this.usbReaders,
    );
  }
}
