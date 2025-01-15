import 'package:equatable/equatable.dart';

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


  factory ReaderDetails.fromJson(Map<String, dynamic> data) {
    return ReaderDetails(
      isFastIdSupported: data["isFastIdSupported"] as bool,
      isQTModeSupported: data["isQTModeSupported"] as bool,
      linkProfile: data["linkProfile"] as int,
      maximumCarrierPower: data["maximumCarrierPower"] as int,
      minimumCarrierPower: data["minimumCarrierPower"] as int,
      model: data["model"] as String,
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