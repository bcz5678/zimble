import 'package:equatable/equatable.dart';

class BluetoothDevice extends Equatable {
  const BluetoothDevice({
    this.macAddress,
    this.name,
    this.serialNumber,
    this.connectionStatus,
  });

  /// The current reader's MAC Address
  final String? macAddress;

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// IS the reader connected
  final bool? connectionStatus;


  /// Converts [BluetoothReader] to [Reader]

  Map<String, dynamic> toJson() =>
    {
      'macAddress': macAddress,
      'name': name,
      'serialNumber': serialNumber,
      'connectionStatus': connectionStatus,
    };

  factory BluetoothDevice.fromMessageData(Map<String, dynamic> data) {
    return BluetoothDevice(
      macAddress: data["address"] as String,
      name: data["name"] as String,
      serialNumber: data['serial_number'] as String,
      connectionStatus: data["connectionStatus"] as bool,
    );
  }

  factory BluetoothDevice.fromJson(Map<String, dynamic> data) {
    return BluetoothDevice(
      macAddress: data["address"] as String,
      name: data["name"] as String,
      serialNumber: data['serial_number'] as String,
      connectionStatus: data["connectionStatus"] as bool,
    );
  }


  @override
  List<Object?> get props =>[
    macAddress,
    name,
    serialNumber,
    connectionStatus,
  ];
}