import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:reader_client/reader_client.dart';

class TagData extends Equatable{
  const TagData({
    this.epc,
    this.tidData,
    this.rssi,
    this.rssiPercent,
    this.pc,
    this.crc,
    this.qt,
    this.didKill,
    this.didLock,
    this.channelFrequency,
    this.phase,
    this.timestamp,
    this.index,
    this.accessErrorCode,
    this.backscatterErrorCode,
    this.readData,
    this.wordsWritten,
    this.isDuplicate,
  });

  final String? epc;
  final String? tidData;
  final int? rssi;
  final int? rssiPercent;
  final int? pc;
  final int? crc;
  final int? qt;
  final bool? didKill;
  final bool? didLock;
  final int? channelFrequency;
  final int? phase;
  final String? timestamp;
  final int? index;
  final String? accessErrorCode;
  final String? backscatterErrorCode;
  final String? readData;
  final int? wordsWritten;
  final bool? isDuplicate;

  factory TagData.fromJson (Map<String, dynamic> data) {
    return TagData(
        epc: data['epc'] as String,
        tidData: data['tidData'] as String,
        rssi: data['rssi'] as int,
        rssiPercent: data['rssiPercent'] as int,
        pc: data['pc'] as int,
        crc: data['crc'] as int,
        qt: data['qt'] as int,
        didKill: data['didKill'] as bool,
        didLock: data['didLock'] as bool,
        channelFrequency: data['channelFrequency'] as int,
        phase: data['phase'] as int,
        timestamp: data['timestamp'] as String,
        index: data['index'] as int,
        accessErrorCode: data['accessErrorCode'] as String,
        backscatterErrorCode: data['backscatterErrorCode'] as String,
        readData: data['readData'] as String,
        wordsWritten: data['wordsWritten'] as int,
        isDuplicate: data['isDuplicate'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    epc,
    tidData,
    rssi,
    rssiPercent,
    pc,
    crc,
    qt,
    didKill,
    didLock,
    channelFrequency,
    phase,
    timestamp,
    index,
    accessErrorCode,
    backscatterErrorCode,
    readData,
    wordsWritten,
    isDuplicate,
  ];
}
