// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:native_channels_client/native_channels_client.dart';

void main() {
  group('NativeChannelsClient', () {
    test('can be instantiated', () {
      expect(NativeChannelsClient(), isNotNull);
    });
  });
}
