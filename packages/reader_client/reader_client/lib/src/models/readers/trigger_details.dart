import 'package:equatable/equatable.dart';

class TriggerDetails extends Equatable {
  const TriggerDetails({
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


  factory TriggerDetails.fromJson(Map<String, dynamic> data) {

    return TriggerDetails(
      doublePressRepeatDelay: data['doublePressRepeatDelay'] as int,
      implementsReadParameters: data['implementsReadParameters'] as bool,
      implementsResetParameters: data['implementsResetParameters'] as bool,
      implementsTakeNoAction: data['implementsTakeNoAction'] as bool,
      pollingReportingEnabled: data['pollingReportingEnabled'] as bool,
      singlePressRepeatDelay: data['singlePressRepeatDelay'] as int,
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