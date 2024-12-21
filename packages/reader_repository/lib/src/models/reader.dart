import 'package:equatable/equatable.dart';
import 'package:reader_client/reader_client.dart';


/// Reader model
///
class Reader extends Equatable{
  const Reader({
    this.serialNumber,
    this.readerType,
    this.name,
    this.connectionStatus,
    this.modelNumber,
    this.macAddress,
    this.ipAddress,
    this.imageStub,
    this.readerDetails,
    this.triggerStatus,
  });

  /// The current reader's type (BT, USB, networked)
  final ReaderType? readerType;

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// The current reader's rfid model
  final String? modelNumber;

  /// The current Bluetooth/LAN reader's macAddress
  final String? macAddress;

  /// The current LAN reader's ipAddress
  final String? ipAddress;

  /// The current reader's display image
  final String? imageStub;

  /// IS the reader connected
  final bool? connectionStatus;

  /// The current reader details
  final Map<String, dynamic>? readerDetails;

  /// The current reader details
  final Map<String, dynamic>? triggerStatus;


  factory Reader.fromJson(Map<String, dynamic> data) {
    return Reader(
      serialNumber: data['serial_number'] as String,
      readerType: data['readerType'] as ReaderType,
      name: data['display_name'] as String,
      modelNumber: data['model_number'] as String,
      imageStub: data['image_stub'] as String,
    );
  }

  /// Converts [BluetoothReader] to [Reader]
  factory Reader.fromBluetoothReader({
    required BluetoothReader bluetoothReader,
  }) =>
    Reader(
      serialNumber: bluetoothReader.serialNumber,
      readerType: ReaderType.bluetooth,
      name: bluetoothReader.name,
      imageStub: bluetoothReader.imageStub,
    );

  @override
  List<Object?> get props => [
    serialNumber,
    readerType,
    name,
    modelNumber,
    imageStub,
  ];
}

enum ReaderType {
  bluetooth,
  usb,
  network,
}