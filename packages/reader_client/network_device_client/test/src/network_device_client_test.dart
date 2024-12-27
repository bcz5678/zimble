// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:network_device_client/network_device_client.dart';

void main() {
  group('NetworkDeviceClient', () {
    test('can be instantiated', () {
      expect(NetworkDeviceClient(), isNotNull);
    });
  });
}
