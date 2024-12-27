import 'package:equatable/equatable.dart';

class GenericDevice extends Equatable {
  const GenericDevice({
    this.name,
    this.serialNumber,
    this.ipAddress,
    this.macAddress,
    this.connectionStatus,
  });

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// The current reader's IP Address
  final String? ipAddress;

  /// The current reader's MAC Address
  final String? macAddress;

  /// IS the reader connected
  final bool? connectionStatus;

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'serialNumber': serialNumber,
        'ipAddress': ipAddress,
        'macAddress': macAddress,
        'connectionStatus': connectionStatus,
      };

  factory GenericDevice.fromMessageData(Map<String, dynamic> data) {
    return GenericDevice(
      name: data['name'] as String,
      serialNumber: data['serial_number'] as String,
      ipAddress: data['ipAddress'] as String,
      macAddress: data['macAddress'] as String,
      connectionStatus: data['connectionStatus'] as bool,
    );
  }


  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    ipAddress,
    macAddress,
    connectionStatus,
  ];
}