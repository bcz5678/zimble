import 'package:equatable/equatable.dart';

class BluetoothReader extends Equatable{
  const BluetoothReader ({
    this.name,
    this.serialNumber,
    this.modelNumber,
    this.macAddress,
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

  /// The current reader's MAC Address
  final String? macAddress;

  /// The current reader's display image
  final String? imageStub;

  /// IS the reader connected
  final String? connectionStatus;

  /// The current reader details
  final Map<String, dynamic>? readerDetails;

  /// The current reader details
  final Map<String, dynamic>? triggerStatus;

  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    modelNumber,
    macAddress,
    imageStub,
    connectionStatus,
    readerDetails,
    triggerStatus,
  ];
}
