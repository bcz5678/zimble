import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'reader_details.dart';
import 'trigger_settings.dart';


class BluetoothReader extends Equatable{
  const BluetoothReader ({
    this.name,
    this.serialNumber,
    this.macAddress,
    this.imageStub,
    this.connectionStatus,
    this.readerDetails,
    this.triggerSettings,
  });

  /// The current reader's name
  final String? name;

  /// The current reader's serial number
  final String? serialNumber;

  /// The current reader's MAC Address
  final String? macAddress;

  /// The current reader's display image
  final String? imageStub;

  /// IS the reader connected
  final bool? connectionStatus;

  /// The current reader details
  final ReaderDetails? readerDetails;

  /// The current reader details
  final TriggerSettings? triggerSettings;

  factory BluetoothReader.fromMessageData(Map<String, dynamic> messageData) {
    final result = messageData['bluetoothDeviceEntity'];
    return BluetoothReader(
      name: result['name'] != null ? result['name']as String : null,
      serialNumber: result['serialNumber'] != null ? result['serialNumber'] as String : null,
      macAddress: result['address'] != null ? result['address'] as String : null,
      imageStub: result['imageStub'] != null ? result['imageStub'] as String : null,
      connectionStatus: result['connectionStatus'] != null ?  result['connectionStatus'] as bool : false,
      readerDetails: result['readerDetails'] != null ? ReaderDetails.fromJson(result['readerDetails'].toString()) : null,
      triggerSettings: result['triggerSettings'] != null ? TriggerSettings.fromJson(result['triggerSettings'].toString()) : null,
    );
  }

  @override
  List<Object?> get props =>[
    name,
    serialNumber,
    macAddress,
    imageStub,
    connectionStatus,
    readerDetails,
    triggerSettings,
  ];
}
