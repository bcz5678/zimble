import 'dart:async';
import 'package:native_channels_client/native_channels_client.dart';

///BAse Exception class
abstract class NativeChannelClientException implements Exception {
  const NativeChannelClientException(this.error);

  /// The error which was caught.
  final Object error;
}

///EXCEPTION HANDLERS
///
/// Thrown during the get paired bluetooth devices process if a failure occurs.
class SendMethodChannelFailure extends NativeChannelClientException {
  const SendMethodChannelFailure(super.error);
}

class OpenEventChannelFailure extends NativeChannelClientException {
  const OpenEventChannelFailure(super.error);
}

class CloseEventChannelFailure extends NativeChannelClientException {
  const CloseEventChannelFailure(super.error);
}


/// Method and Event Channel helpers
class NativeChannelsClient {
  const NativeChannelsClient();


}
