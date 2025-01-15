import 'package:equatable/equatable.dart';
import 'reader_details.dart';
import 'trigger_details.dart';


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
  final bool? connectionStatus;

  /// The current reader details
  final ReaderDetails? readerDetails;

  /// The current reader details
  final TriggerDetails? triggerStatus;

  factory BluetoothReader.fromMessageData(Map<String, dynamic> messageData) {
    final result = messageData['bluetoothDeviceEntity'] as Map<String, dynamic>;
    return BluetoothReader(
      name: result['name'] as String,
      serialNumber: result['serialNumber'] as String,
      macAddress: result['adddress'] as String,
      imageStub: result['imageStub'] as String,
      connectionStatus: result['connectionStatus'] as bool,
      readerDetails: ReaderDetails.fromJson(result['readerDetails'] as Map<String, dynamic>),
      triggerStatus: TriggerDetails.fromJson(result['triggerDetails']as Map<String, dynamic>),

    );
  }

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
