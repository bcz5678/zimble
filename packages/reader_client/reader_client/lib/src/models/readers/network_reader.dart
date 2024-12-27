import 'package:equatable/equatable.dart';

class NetworkReader extends Equatable{
  const NetworkReader ({
    this.name,
    this.serialNumber,
    this.modelNumber,
    this.ipAddress,
    this.imageStub,
    this.connectionStatus,
    this.readerDetails,
    this.triggerStatus,
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
  final Map<String, dynamic>? readerDetails;

  /// The current reader details
  final Map<String, dynamic>? triggerStatus;

  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    modelNumber,
    ipAddress,
    imageStub,
    connectionStatus,
    readerDetails,
    triggerStatus,
  ];
}
