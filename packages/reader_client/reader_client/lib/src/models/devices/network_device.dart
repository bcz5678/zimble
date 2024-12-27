import 'package:equatable/equatable.dart';

class NetworkDevice extends Equatable {
  const NetworkDevice({
    this.name,
    this.serialNumber,
    this.ipAddress,
    this.connectionStatus,
  });

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// The current reader's IP Address
  final String? ipAddress;

  /// IS the reader connected
  final bool? connectionStatus;


  /// Converts [BluetoothReader] to [Reader]

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'serialNumber': serialNumber,
        'ipAddress': ipAddress,
        'connectionStatus': connectionStatus,
      };

  factory NetworkDevice.fromMessageData(Map<String, dynamic> data) {
    return NetworkDevice(
      name: data['name'] as String,
      serialNumber: data['serial_number'] as String,
      ipAddress: data['ipAddress'] as String,
      connectionStatus: data['connectionStatus'] as bool,
    );
  }


  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    ipAddress,
    connectionStatus,
  ];
}