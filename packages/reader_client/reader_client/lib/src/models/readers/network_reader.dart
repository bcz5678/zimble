import 'package:equatable/equatable.dart';
import 'package:reader_client/reader_client.dart';

class NetworkReader extends Equatable{
  const NetworkReader ({
    this.name,
    this.serialNumber,
    this.modelNumber,
    this.ipAddress,
    this.imageStub,
    this.connectionStatus,
    this.readerDetails,
    this.triggerSettings,
  });

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// The current reader's rfid model
  final String? modelNumber;

  /// The current reader's IP Address
  final String? ipAddress;

  /// The current reader's display image
  final String? imageStub;

  /// IS the reader connected
  final bool? connectionStatus;

  /// The current reader details
  final ReaderDetails? readerDetails;

  /// The current reader details
  final TriggerSettings? triggerSettings;

  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    modelNumber,
    ipAddress,
    imageStub,
    connectionStatus,
    readerDetails,
    triggerSettings,
  ];
}
