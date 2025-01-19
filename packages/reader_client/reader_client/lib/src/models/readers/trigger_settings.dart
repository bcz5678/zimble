import 'dart:convert';

import 'package:equatable/equatable.dart';

class TriggerSettings extends Equatable {
  const TriggerSettings({
    this.doublePressRepeatDelay,
    this.implementsReadParameters,
    this.implementsResetParameters,
    this.implementsTakeNoAction,
    this.pollingReportingEnabled,
    this.singlePressRepeatDelay,
  });

  ///
  final int? doublePressRepeatDelay;

  ///
  final bool? implementsReadParameters;

  ///
  final bool? implementsResetParameters;

  ///
  final bool? implementsTakeNoAction;

  ///
  final bool? pollingReportingEnabled;

  ///
  final int? singlePressRepeatDelay;


  factory TriggerSettings.fromJson(String data) {

    final Map<String, dynamic> dataMap = json.decode(data) as Map<String, dynamic>;

    return TriggerSettings(
      doublePressRepeatDelay: dataMap['doublePressRepeatDelay'] != null ? dataMap['doublePressRepeatDelay'] as int : null,
      implementsReadParameters: dataMap['implementsReadParameters'] != null ? dataMap['implementsReadParameters'] as bool : null,
      implementsResetParameters: dataMap['implementsResetParameters'] != null ? dataMap['implementsResetParameters'] as bool : null,
      implementsTakeNoAction: dataMap['implementsTakeNoAction'] != null ? dataMap['implementsTakeNoAction'] as bool : null,
      pollingReportingEnabled: dataMap['pollingReportingEnabled'] != null ? dataMap['pollingReportingEnabled'] as bool : null,
      singlePressRepeatDelay: dataMap['singlePressRepeatDelay'] != null ? dataMap['singlePressRepeatDelay'] as int : null,
    );
  }


  @override
  List<Object?> get props =>[
    doublePressRepeatDelay,
    implementsReadParameters,
    implementsResetParameters,
    implementsTakeNoAction,
    pollingReportingEnabled,
    singlePressRepeatDelay,
  ];

}