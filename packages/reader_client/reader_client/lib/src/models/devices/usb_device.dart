import 'package:equatable/equatable.dart';

class UsbDevice extends Equatable {
  const UsbDevice({
    this.name,
    this.serialNumber,
    this.macAddress,
    this.connectionStatus,
  });

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// The current reader's MAC Address
  final String? macAddress;

  /// IS the reader connected
  final bool? connectionStatus;


  /// Converts [BluetoothReader] to [Reader]

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'serialNumber': serialNumber,
        'macAddress': macAddress,
        'connectionStatus': connectionStatus,
      };

  factory UsbDevice.fromMessageData(Map<String, dynamic> data) {
    return UsbDevice(
      name: data["name"] as String,
      macAddress: data["address"] as String,
      serialNumber: data['serial_number'] as String,
      connectionStatus: data["connectionStatus"] as bool,
    );
  }


  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    macAddress,
    connectionStatus,
  ];
}