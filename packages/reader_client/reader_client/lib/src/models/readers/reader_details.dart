import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ReaderDetails extends Equatable {
  const ReaderDetails ({
    this.isFastIdSupported,
    this.isQTModeSupported,
    this.linkProfile,
    this.maximumCarrierPower,
    this.minimumCarrierPower,
    this.model,
  });

  /// Is the FastID protocol supported
  final bool? isFastIdSupported;

  /// Is QTMode supported
  final bool? isQTModeSupported;

  ///
  final int? linkProfile;

  ///
  final int? maximumCarrierPower;

  ///
  final int? minimumCarrierPower;

  ///
  final String? model;


  factory ReaderDetails.fromJson(String data) {
    final Map<String, dynamic> dataMap = json.decode(data) as Map<String, dynamic>;

    return ReaderDetails(
      isFastIdSupported: dataMap['isFastIdSupported'] != null ? dataMap['isFastIdSupported'] as bool : null,
      isQTModeSupported: dataMap['isQTModeSupported'] != null ? dataMap['isQTModeSupported'] as bool : null,
      linkProfile: dataMap['linkProfile'] != null ? dataMap['linkProfile'] as int : null,
      maximumCarrierPower: dataMap['maximumCarrierPower'] != null ? dataMap['maximumCarrierPower'] as int : null,
      minimumCarrierPower: dataMap['minimumCarrierPower'] != null ? dataMap['minimumCarrierPower'] as int : null,
      model: dataMap['model'] != null ? dataMap['model'] as String : null,
    );
  }


  @override
  List<Object?> get props =>[
    isFastIdSupported,
    isQTModeSupported,
    linkProfile,
    maximumCarrierPower,
    minimumCarrierPower,
    model,

  ];
}