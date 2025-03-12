import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:reader_client/reader_client.dart';

class TagScanData extends Equatable{
  const TagScanData({
    this.epc,
    this.tidData,
    this.rssi,
    this.pc,
    this.crc,
    this.channelFrequency,
  });

  final String? epc;
  final String? tidData;
  final int? rssi;
  final int? pc;
  final int? crc;
  final int? channelFrequency;

  factory TagScanData.fromJson (Map<String, dynamic> data) {
    return TagScanData(
        epc: data['epc'] as String,
        tidData: data['tidData'] as String?,
        rssi: data['rssi'] as int?,
        pc: data['pc'] as int?,
        crc: data['crc'] as int?,
        channelFrequency: data['channelFrequency'] as int?,
    );
  }
  TagScanData copyWith({
    String? epc,
    String? tidData,
    int? rssi,
    int? pc,
    int? crc,
    int? channelFrequency,
}){
    return TagScanData(
      epc: epc ?? this.epc,
      tidData: tidData ?? this.tidData,
      rssi: rssi ?? this.rssi,
      pc: pc ?? this.pc,
      crc: crc ?? this.crc,
      channelFrequency: channelFrequency ?? this.channelFrequency,
    );
  }

  @override
  List<Object?> get props => [
    epc,
    tidData,
    rssi,
    pc,
    crc,
    channelFrequency,
  ];
}
